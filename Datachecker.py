# -*- coding: utf-8 -*-
"""
/***************************************************************************
 Datachecker
                                 A QGIS plugin
 riool datachecker
 Generated by Plugin Builder: http://g-sherman.github.io/Qgis-Plugin-Builder/
                              -------------------
        begin                : 2020-01-21
        git sha              : $Format:%H$
        copyright            : (C) 2020 by OAS-De Groote Lucht
        email                : o.claassen@schiedam.nl
 ***************************************************************************/

/***************************************************************************
 *                                                                         *
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the GNU General Public License as published by  *
 *   the Free Software Foundation; either version 2 of the License, or     *
 *   (at your option) any later version.                                   *
 *                                                                         *
 ***************************************************************************/
"""
from PyQt5.QtCore import QObject, QSettings, QTranslator, qVersion, QCoreApplication, Qt
from PyQt5.QtGui import QIcon
from PyQt5.QtWidgets import QAction, QFileDialog, QInputDialog, QLineEdit, QMessageBox
from qgis.core import (
    QgsProject,
    QgsVectorLayer,
    QgsLayerTreeLayer,
    QgsApplication,
    QgsTask,
    QgsMessageLog,
    QgsEditorWidgetSetup,
    QgsMapLayer,
)

from qgis.utils import iface

# Initialize Qt resources from file resources.py
from .resources import *
import os
import glob
from osgeo import ogr

# Import the code for the DockWidget
from .Datachecker_dockwidget import DatacheckerDockWidget
import os.path
from .tool_quality_checks.scripts import run_scripts, run_scripts_task
from pathlib import Path, PureWindowsPath

# Debugging in vs : https://gist.github.com/AsgerPetersen/9ea79ae4139f4977c31dd6ede2297f90

velden = {
    "min_levels",
    "max_levels",
    "min_length",
    "max_length",
    "max_verhang",
    "min_dekking",
    "hoogte_verschil",
    "min_dimensions",
    "max_dimensions",
    "padding_manhole",
}


class SettingsObjectPlugin(object):
    """Contains the settings from the ini file"""

    def __init__(self):

        self.origin = "plugin"               
        self.host = "localhost"
        self.database = "work_checks_in_gui"
        self.port="5432"
        self.username = "postgres"
        self.password = "postgres"
        self.dropdb = False
        self.createdb = False
        self.emptydb = False
        self.import_type = ''
        self.export = False
        self.gpkg_output_layer = ''
        self.checks = False
        self.max_connections = 8
 

class Datachecker:
    """QGIS Plugin Implementation."""

    def __init__(self, iface):
        """Constructor.

        :param iface: An interface instance that will be passed to this class
            which provides the hook by which you can manipulate the QGIS
            application at run time.
        :type iface: QgsInterface
        """
        # Save reference to the QGIS interface
        self.iface = iface

        # initialize plugin directory
        self.plugin_dir = os.path.dirname(__file__)

        # initialize locale
        locale = QSettings().value("locale/userLocale")[0:2]
        locale_path = os.path.join(
            self.plugin_dir, "i18n", "datachecker_{}.qm".format(locale)
        )
        # print(locale_path)

        if os.path.exists(locale_path):
            self.translator = QTranslator()
            self.translator.load(locale_path)

            if qVersion() > "4.3.3":
                QCoreApplication.installTranslator(self.translator)

        # Declare instance attributes
        self.actions = []
        self.menu = self.tr(u"&Riooldatachecker")
        # TODO: We are going to let the user set this up in a future iteration
        self.toolbar = self.iface.addToolBar(u"Datachecker")
        self.toolbar.setObjectName(u"Datachecker")

        # print "** INITIALIZING Datachecker"

        self.pluginIsActive = False
        self.dockwidget = None

    # noinspection PyMethodMayBeStatic
    def tr(self, message):
        """Get the translation for a string using Qt translation API.

        We implement this ourselves since we do not inherit QObject.

        :param message: String for translation.
        :type message: str, QString

        :returns: Translated version of message.
        :rtype: QString
        """
        # noinspection PyTypeChecker,PyArgumentList,PyCallByClass
        return QCoreApplication.translate("Datachecker", message)

    def add_action(
            self,
            icon_path,
            text,
            callback,
            enabled_flag=True,
            add_to_menu=True,
            add_to_toolbar=True,
            status_tip=None,
            whats_this=None,
            parent=None,
    ):
        """Add a toolbar icon to the toolbar.

        :param icon_path: Path to the icon for this action. Can be a resource
            path (e.g. ':/plugins/foo/bar.png') or a normal file system path.
        :type icon_path: str

        :param text: Text that should be shown in menu items for this action.
        :type text: str

        :param callback: Function to be called when the action is triggered.
        :type callback: function

        :param enabled_flag: A flag indicating if the action should be enabled
            by default. Defaults to True.
        :type enabled_flag: bool

        :param add_to_menu: Flag indicating whether the action should also
            be added to the menu. Defaults to True.
        :type add_to_menu: bool

        :param add_to_toolbar: Flag indicating whether the action should also
            be added to the toolbar. Defaults to True.
        :type add_to_toolbar: bool

        :param status_tip: Optional text to show in a popup when mouse pointer
            hovers over the action.
        :type status_tip: str

        :param parent: Parent widget for the new action. Defaults None.
        :type parent: QWidget

        :param whats_this: Optional text to show in the status bar when the
            mouse pointer hovers over the action.

        :returns: The action that was created. Note that the action is also
            added to self.actions list.
        :rtype: QAction
        """

        icon = QIcon(icon_path)
        action = QAction(icon, text, parent)
        action.triggered.connect(callback)
        action.setEnabled(enabled_flag)

        if status_tip is not None:
            action.setStatusTip(status_tip)

        if whats_this is not None:
            action.setWhatsThis(whats_this)

        if add_to_toolbar:
            self.toolbar.addAction(action)

        if add_to_menu:
            self.iface.addPluginToMenu(self.menu, action)

        self.actions.append(action)

        return action

    def initGui(self):
        """Create the menu entries and toolbar icons inside the QGIS GUI."""

        icon_path = ":/plugins/Datachecker/icon.png"
        self.add_action(
            icon_path,
            text=self.tr(u"Riooldatachecker"),
            callback=self.run,
            parent=self.iface.mainWindow(),
        )

    # --------------------------------------------------------------------------

    def onClosePlugin(self):
        """Cleanup necessary items here when plugin dockwidget is closed"""

        # print "** CLOSING Datachecker"

        # disconnects
        self.dockwidget.closingPlugin.disconnect(self.onClosePlugin)

        # remove this statement if dockwidget is to remain
        # for reuse if plugin is reopened
        # Commented next statement since it causes QGIS crashe
        # when closing the docked window:
        # self.dockwidget = None

        self.pluginIsActive = False

    def unload(self):
        """Removes the plugin menu item and icon from QGIS GUI."""

        # print "** UNLOAD Datachecker"

        for action in self.actions:
            self.iface.removePluginMenu(self.tr(u"&Riooldatachecker"), action)
            self.iface.removeToolBarIcon(action)
        # remove the toolbar
        del self.toolbar

    # --------------------------------------------------------------------------
    def pb_select_dc_folder(self):
        foldername = QFileDialog.getExistingDirectory()
        if foldername:
            self.dockwidget.folderNaam.setText(foldername)
            self.dockwidget.folderNaam.setToolTip(foldername)
            self.fill_checks_list()

    def fill_checks_list(self):
        self.dockwidget.listChecks.clear()
        foldername = self.dockwidget.folderNaam.text()
        geopackageList = []
        for file in os.listdir(foldername):
            if file.endswith(".gpkg"):
                geopackageList.append(file)
        self.dockwidget.listChecks.addItems(geopackageList)

    def getConnectionDetails(self, value):
        type = value.split()[0]
        value = value.split()[1]

        if type == "Postgresql:":
            password = self.s_postgresql.value(value + "/password")
            username = self.s_postgresql.value(value + "/username")
            port = self.s_postgresql.value(value + "/port")
            host = self.s_postgresql.value(value + "/host")
            self.threedi_db_settings = {
                "threedi_dbname": value,
                "threedi_host": host,
                "threedi_user": username,
                "threedi_password": password,
                "threedi_port": port,
                "type": "Postgresql",
            }

    def get_databases(self):
        databases = []
        self.s_postgresql = QSettings()
        self.s_postgresql.beginGroup("PostgreSQL/connections")
        all_pgsql_dbkeys = self.s_postgresql.allKeys()
        for key in all_pgsql_dbkeys:
            if not key.startswith('selected'):
                databases.append("Postgresql: " + key.split("/")[0])
        databases = list(dict.fromkeys(databases))
        return databases

    def laad_gpkg(self):
        fileName = self.dockwidget.listChecks.selectedItems()
        # dictionary with layer_names of gpkg and potential group name in QGIS

        group_mapping = {
            "chk.leiding": "leidingen",
            "chk.put": "putten",
            "chk.profiel": "profielen",
            'chk.kunstwerken': 'kunstwerken',
            'model.': 'brongegevens',
        }


        if len(fileName) > 0:
            root = QgsProject.instance().layerTreeRoot()
            for gpkg in fileName:
                foldername = self.dockwidget.folderNaam.text()
                file = os.path.join(foldername, gpkg.text())
                conn = ogr.Open(file)

                for key, value in group_mapping.items():
                    group = root.addGroup(value)
                    for layer in conn:
                        if layer.GetName().split('_')[0] == key or layer.GetName().startswith(key):
                            if layer.GetFeatureCount() > 0:
                                combined = file + "|layername={}".format(layer.GetName())
                                vlayer = QgsVectorLayer(combined, layer.GetName(), "ogr")
                                QgsProject.instance().addMapLayer(vlayer, False)
                                group.addLayer(vlayer)

        root = QgsProject.instance().layerTreeRoot()
        for child in root.children():
            if child.name() in group_mapping.values():
                for child2 in child.children():
                    if isinstance(child2, QgsLayerTreeLayer):
                        child2.setCustomProperty("showFeatureCount", True)
        self.laad_qml_styling('beheerder-std')
        self.dockwidget.stylingbox.setCurrentIndex(2)


    def pb_select_exp_folder(self):
        foldername = QFileDialog.getExistingDirectory()
        if foldername:
            self.dockwidget.folderNaam_export.setText(foldername)
            self.dockwidget.folderNaam_export.setToolTip(foldername)
            self.fill_export_list()

    def fill_export_list(self):
        self.dockwidget.listExport.clear()
        foldername = self.dockwidget.folderNaam_export.text()
        exportList = []
        for file in os.listdir(foldername):
            if file.endswith(".shp"):
                exportList.append(file)
        self.dockwidget.listExport.addItems(exportList)


    def save_qml_styling(self):  #,style_dir):
        scriptLocatie =os.path.dirname(os.path.realpath(__file__))
        stijlgroep = self.dockwidget.stylingbox.currentText() # 'Beheerder-std'
        style_dir = os.path.join(scriptLocatie, 'styling', stijlgroep)
        # style_dir=r'C:\Users\onnoc\AppData\Roaming\QGIS\QGIS3\profiles\default\python\plugins\OASDGLDatachecker\styling\Stylingbeheerder'
        for layer in QgsProject.instance().mapLayers().values():
            file = os.path.join(style_dir, layer.name() + ".qml")
            if os.path.exists(file):
                os.remove(file)
            # layer.exportNamedStyle(file, "test")   
            layer.saveNamedStyle(file)
            # print(result)

    def laad_qml_styling(self, stylingnaam):
        if not stylingnaam :
            folder = "styling\\" + self.dockwidget.stylingbox.currentText()
        else:
            folder = "styling\\" + stylingnaam
        # print(folder)
        for layer in QgsProject.instance().mapLayers().values():
            scriptLocatie = os.path.dirname(os.path.realpath(__file__))
            qmlpad = os.path.join(scriptLocatie, folder, layer.name()) + ".qml"
            layer.loadNamedStyle(qmlpad)
            layer.triggerRepaint()
            # print(layer.name())
            print(qmlpad)
        self.configure_dropdown()

    def add_qml_styling(self):
        qid = QInputDialog()
        title = "Nieuwe Stijling groep"
        label = "Naam stijling groep: "
        mode = QLineEdit.Normal
        default = "<your name here>"
        text, ok = QInputDialog.getText(qid, title, label, mode, default)
        if ok and text and not text==default:
            scriptLocatie =os.path.dirname(os.path.realpath(__file__))
            folder = os.path.join(scriptLocatie, 'styling', text)
            print(folder)
            if not os.path.exists(folder):                
                os.makedirs(folder,exist_ok=True) 
            stylingfolders = self.get_stylingfolders()
            self.dockwidget.stylingbox.clear()
            self.dockwidget.stylingbox.addItems(stylingfolders)
            self.dockwidget.stylingbox.setCurrentText(text)

    def remove_qml_styling(self):
        stylinggroup = self.dockwidget.stylingbox.currentText()
        msgbox = QMessageBox() # https://www.riverbankcomputing.com/static/Docs/PyQt4/qmessagebox.html#details
        msgbox.setText("De stijlgroep: '" + stylinggroup + "' wordt verwijderd als je doorgaat.")
        msgbox.setInformativeText("Wil je doorgaan?")
        msgbox.setStandardButtons(QMessageBox.Ok | QMessageBox.Cancel)
        ret = msgbox.exec_()        
        if not stylinggroup in ['Beheerder-std', 'Modelleur-std']:
            if ret == QMessageBox.Ok:
                scriptLocatie =os.path.dirname(os.path.realpath(__file__))
                folder = os.path.join(scriptLocatie, 'styling', stylinggroup)
                print(folder)
                # subfolders = [ f.name for f in os.scandir(folder) if f.is_dir() ]
                files = glob.glob(os.path.join(folder, '*'))
                for file in files:
                    os.remove(file)
                os.rmdir(folder)
                self.dockwidget.stylingbox.clear()
                stylingfolders = self.get_stylingfolders()
                self.dockwidget.stylingbox.addItems(stylingfolders)


    def update_status(self, waarde):
        # waarde='verwerkt'
        lyr = iface.activeLayer()
        lyr.startEditing()
        features = lyr.selectedFeatures()
        lyr.updateFields()
        idx = lyr.fields().indexFromName("status")
        for f in features:
            print(f)
            lyr.changeAttributeValue(f.id(), idx, waarde)
        lyr.commitChanges()
        # self.filter_status()


    def filter_status(self, waarde, filter):
        # filter = true
        statement = "status is null or status IN ()"
        basis = "status is null or status IN ("
        oldstatement = ""
        try:
            oldstatement = iface.activeLayer().subsetString()
            if filter:
                if not basis in oldstatement:
                    statement = basis + "'" + waarde + "')"
                elif oldstatement.find(waarde) == -1:
                    statement = oldstatement.replace(basis, "")
                    statement = statement.replace(")", "")
                    if len(statement) == 0:
                        statement = basis + "'" + waarde + "')"
                    elif len(statement) > 2:
                        statement = basis + statement + ",'" + waarde + "')"
                else:
                    statement = oldstatement
            else:
                if not basis in oldstatement:
                    statement = "status is null or status IN ('gecontroleerd', 'verwerkt')"
                    if waarde == 'gecontroleerd':
                        statement = statement.replace("'" + waarde + "', ","")
                    else:
                        statement = statement.replace(", '" + waarde + "'","")
                elif oldstatement.find(waarde) == -1:
                    statement = oldstatement
                else:
                    statement = oldstatement.replace(basis, "")
                    statement = statement.replace(")", "")
                    statement = statement.replace("'" + waarde + "'","")
                    if len(statement) == 0:
                        statement = basis +  ")"
                    elif len(statement) > 2:
                        statement = statement.replace(",," ,",")
                        statement = statement.strip(",")
                        statement = basis +  statement + ")"
        except:
        #    statement = "status is null or status IN (gecontroleerd, verwerkt)"
            pass

        if not statement in [ oldstatement, ""]:
            for layer in QgsProject.instance().mapLayers().values():
                if layer.name().startswith("chk."):
                    layer.setSubsetString(statement)



    def configure_dropdown(self):
        for layer in QgsProject.instance().mapLayers().values():

            idx = layer.fields().indexFromName("status")
            editor_widget_setup = QgsEditorWidgetSetup(
                "ValueMap",
                {"map": {u"gecontroleerd": u"gecontroleerd", u"verwerkt": u"verwerkt"}},
            )
            layer.setEditorWidgetSetup(idx, editor_widget_setup)
            QSettings().setValue("/Map/identifyAutoFeatureForm", "true")


    def get_stylingfolders(self):
        scriptLocatie =os.path.dirname(os.path.realpath(__file__))
        folder = os.path.join(scriptLocatie, 'styling')        
        # folder = r'C:\Users\onnoc\AppData\Roaming\QGIS\QGIS3\profiles\default\python\plugins\OASDGLDatachecker\styling'
        subfolders = [ f.name for f in os.scandir(folder) if f.is_dir() ]
        return subfolders

    def save_folderchecks(self):
        folderchecks = os.path.realpath(self.dockwidget.folderNaam.text())
        self.save_qsetting("paths", "folderchecks", folderchecks)

    def save_folderbeheerexport(self):
        folderchecks = os.path.realpath(self.dockwidget.folderNaam_export.text())
        self.save_qsetting("paths", "folderbeheerexport", folderchecks)

    def save_leidingfile(self):
        leidingfile = os.path.realpath(self.dockwidget.leidingFile.filePath())
        self.save_qsetting("paths", "leidingfile", leidingfile)

    def save_putfile(self):
        # putfile = os.path.dirname(os.path.realpath(self.dockwidget.putFile.filePath()))
        putfile = os.path.realpath(self.dockwidget.putFile.filePath())
        self.save_qsetting('paths', 'putfile', putfile)

    def save_DEMfile(self):
        DEMfile = os.path.realpath(self.dockwidget.dem.filePath())
        self.save_qsetting('paths', 'DEMfile', DEMfile)

    def create_db_from_qgis(self):
        settings = SettingsObjectPlugin()
        settings.createdb = True
        settings.database = self.dockwidget.dbName.text()
        settings.host = self.dockwidget.dbHost.text()
        settings.port = self.dockwidget.dbPort.text()
        settings.username = self.dockwidget.dbUsername.text()
        settings.password = self.dockwidget.dbPassword.text()
        # settings.s = self.dockwidget.?
        run_scripts(settings)
        qgs_settings = QSettings()
        qgs_settings.setValue('PostgreSQL/connections/'+settings.database+'/host', settings.host)
        qgs_settings.setValue('PostgreSQL/connections/'+settings.database+'/port', settings.port)
        qgs_settings.setValue('PostgreSQL/connections/'+settings.database+'/username', settings.username)
        qgs_settings.setValue('PostgreSQL/connections/'+settings.database+'/password', settings.password)
        qgs_settings.setValue('PostgreSQL/connections/'+settings.database+'/database', settings.database)
        qgs_settings.setValue('PostgreSQL/connections/'+settings.database+'/saveUsername', True)
        qgs_settings.setValue('PostgreSQL/connections/'+settings.database+'/savePassword', True)
        databases=self.get_databases()
        self.dockwidget.bestaandeDatabases.clear()
        self.dockwidget.bestaandeDatabases.addItems(databases)


    def get_settings(self):  #vul_settings

        settings = SettingsObjectPlugin()
        # settings.s='localhost' #self.threedi_db_settings["threedi_host"]
        self.getConnectionDetails
        settings.host = self.threedi_db_settings['threedi_host']
        settings.database = self.threedi_db_settings['threedi_dbname']
        settings.port = self.threedi_db_settings['threedi_port']
        settings.username = self.threedi_db_settings['threedi_user']
        settings.password = self.threedi_db_settings['threedi_password']
        settings.emptydb = True

        settings.import_type = self.get_qsetting("Instellingen", "ImportSoftware") #"gbi"
        if not settings.import_type or settings.import_type == "":
            settings.import_type ="gbi"

        settings.export = True
        settings.gpkg_output_layer = self.dockwidget.outputFileName.text()
        settings.checks = True
        # settings.checks = False
        settings.max_connections = 8

        putfile = self.get_qsetting("paths", "putfile")
        settings.manhole_layer = putfile
        leidingfile = self.get_qsetting("paths", "leidingfile")
        settings.pipe_layer = leidingfile

        settings.dem = os.path.realpath(self.dockwidget.dem.filePath())
        #'C:\\Users\onnoc\AppData\Roaming\QGIS\QGIS3\profiles\default\python\plugins\OASDGLDatachecker\tool_quality_checks\test\data\schiedam-test\dem_schiedam_test.tif')
        self.instellingen_ophalen(settings)

        print(settings.__dict__)
        # run_scripts(settings)
        # settings.dropdb = False
        # settings.createdb = False
        return settings

    
    def completed(self, result):#,exception, result=None):
        """This is called when doSomething is finished.
        Exception is not None if doSomething raises an exception.
        result is the return value of doSomething."""
        print(result)
        if result:
            self.initialize_paths()
            print('succesfully ran')
        if exception is None:
            if result is None:
                QgsMessageLog.logMessage(
                    'Completed with no exception and no result '\
                    '(probably manually canceled by the user)',
                    MESSAGE_CATEGORY, Qgis.Warning)
            else:
                QMessageBox.information(
                None,
                "Checks outcome",
                "Your checks have ran succesfully",
                )
        else:
            QgsMessageLog.logMessage("Exception: {}".format(exception),
                                     MESSAGE_CATEGORY, Qgis.Critical)
        return

    def slider_function(self, value):
        layer = self.iface.mapCanvas().currentLayer()
        #print(layer.renderer().type())
        #for field in layer.renderer().symbol().symbolLayer(0):
                #print(field.name(), field.typeName())
            #layer.renderer().symbol().symbolLayer(0).setSize(value)
        #layer=iface.mapCanvas().currentLayer()
        #QgsMessageLog.logMessage('stylings opgeslagen', 'datachecker')
        renderer=layer.renderer()
        if hasattr(renderer, 'symbol')==False:
            if hasattr(renderer, 'Rule')==True:
                root_rule=renderer.rootRule()
                for rule in root_rule.children():
                    rule.symbol().setSize(value)            
        
        elif layer.renderer().symbol().type() == 1: # Lijnen
            layer.renderer().symbol().symbolLayer(0).setWidth(value)
            print(layer.renderer().symbol().symbolLayer(0).width())

        elif layer.renderer().symbol().type() == 0:  # symbolen
            # newsize = layer.renderer().symbol().symbolLayer(0).size()*5/value
            layer.renderer().symbol().symbolLayer(0).setSize(value)
            print(layer.renderer().symbol().symbolLayer(0).size())
        layer.triggerRepaint()
        iface.layerTreeView().refreshLayerSymbology(layer.id())
        print(layer.name())
        #print(value)

    def switch_layerIsolate(self, value):
        if value:
            iface.currentLayerChanged.connect(lambda _: self.switch_visibility())

            # iface.layerTreeView().selectionChanged.connect(self.switch_visibility)
            # QObject.connect(self.iface,SIGNAL("currentLayerChanged(QgsMapLayer *)") ,self.switch_visibility)
            # QObject.connect(self.iface.mapCanvas(),SIGNAL("selectionChanged(QgsMapLayer)"), self.switch_visibility)
        else:
            # iface.currentLayerChanged.disconnect(lambda _: self.switch_visibility)
            iface.layerTreeView().currentLayerChanged.disconnect() #lambda _: self.switch_visibility)
            # QObject.disconnect(self.iface,SIGNAL("currentLayerChanged(QgsMapLayer *)") ,self.switch_visibility)
            # QObject.disconnect(self.iface.mapCanvas(),SIGNAL("selectionChanged(QgsMapLayer)"), self.switch_visibility)

    def switch_visibility(self):
        check = self.dockwidget.layerIsolate.checkState()
        if check:
            root = QgsProject.instance().layerTreeRoot()
            allLayers = root.layerOrder()
            for layer in allLayers:
                if layer in iface.layerTreeView().selectedLayers():
                    root.findLayer(layer.id()).setItemVisibilityChecked(True)
                else:
                    root.findLayer(layer.id()).setItemVisibilityChecked(False)



    def instellingen_opslaan(self):
        for veld in velden:
            box = getattr(self.dockwidget, veld)
            waarde = box.value()
            # print(veld, waarde)
            self.save_qsetting("Instellingen", veld, waarde)

    def instellingenDefault_opslaan(self):
        for veld in velden:
            box = getattr(self.dockwidget, veld)
            waarde = box.value()
            # print(veld, waarde)
            self.save_qsetting("InstellingenDefault", veld, waarde)        

    def instellingen_ophalen(self, settings):
        s = QSettings()
        group = "Instellingen"
        for veld in velden:
            value = s.value("OASDGLDatachecker/" + group + "/" + veld)
            setattr(settings, veld, value)
            # print(value)

    def instellingen_laden(self, default=False,initializePlugin=False):
        # default = True
        # initializePlugin = False
        if default:
            group = "InstellingenDefault"
        else:
            group = "Instellingen"
        for veld in velden:
            try:
                s = QSettings()
                value = s.value("OASDGLDatachecker/" + group + "/" + veld)
                box = getattr(self.dockwidget, veld)
                value2  = float(value)
                # print(value2)
                if value:
                    box.valueChanged.disconnect(self.instellingen_opslaan)
                    box.setValue(value2) #float(value) #
                    box.valueChanged.connect(self.instellingen_opslaan)
            except:
                if initializePlugin:
                    self.instellingenDefault_opslaan()
                else:
                    pass

    def importSoftware_opslaan(self,waarde):
        s = QSettings()
        self.save_qsetting("Instellingen", "ImportSoftware", waarde)


    def save_qsetting(self, group, key, value):
        # file waar het opgeslagen wordt: C:\Users\onnoc\AppData\Roaming\QGIS\QGIS3\profiles\default\QGIS\QGIS3.INI
        s = QSettings()
        s.setValue("OASDGLDatachecker/" + group + "/" + key, value)
        test = s.value("OASDGLDatachecker/" + group + "/" + key)

    def get_qsetting(self, group, key):
        s = QSettings()
        try:
            value = s.value('OASDGLDatachecker/' + group + '/' + key)            
            return(value)
        except:
            pass

    def delete_qsetting(self):
        QSettings().remove('UI/recentProjects') # als voorbeeld

    def select_output_file(self):
        file_name = QFileDialog.getSaveFileName(filter="*.gpkg")
        if str(file_name[0]):
            self.dockwidget.outputFileName.setText(str(file_name[0]))
            file_name = os.path.realpath(str(file_name[0]))
            self.save_qsetting('paths', 'outputfile',file_name)

    def draai_de_checks(self):
        settings = self.get_settings()

        task1 = QgsTask.fromFunction('Draai checks', run_scripts_task, on_finished=self.completed, settings=settings)
        QgsApplication.taskManager().addTask(task1)
        #run_scripts(settings)

        self.initialize_paths()
        
    def initialize_paths(self):
        foldernaam = self.get_qsetting("paths", "folderchecks")
        if foldernaam:
            foldernaam = Path(foldernaam)
            self.dockwidget.folderNaam.setText(str(foldernaam))
            self.dockwidget.folderNaam.setToolTip(str(foldernaam))
            self.fill_checks_list()

        foldernaam_export = self.get_qsetting("paths", "folderbeheerexport")
        if foldernaam_export:
            foldernaam_export = Path(foldernaam_export)
            self.dockwidget.folderNaam_export.setText(str(foldernaam_export))
            self.dockwidget.folderNaam_export.setToolTip(str(foldernaam_export))
            self.fill_export_list()

        DEMfile =self.get_qsetting('paths', 'DEMfile')
        if DEMfile:
            print(DEMfile)
            self.dockwidget.dem.setFilePath(os.path.join(str(DEMfile)))
            
        putfile = self.get_qsetting('paths', 'putfile')
        if putfile:
            self.dockwidget.putFile.setFilePath(os.path.join(str(putfile)))
            
        leidingfile = self.get_qsetting('paths', 'leidingfile')
        if leidingfile:     
            self.dockwidget.leidingFile.setFilePath(os.path.join(str(leidingfile)))
        
        importSoftware = self.get_qsetting("Instellingen", "ImportSoftware")
        if importSoftware:
            self.dockwidget.boxSoftware.setCurrentText(importSoftware)
            
        self.instellingen_laden(initializePlugin=True)
        
            


    def run(self):
        """Run method that loads and starts the plugin"""
        if not self.pluginIsActive:
            self.pluginIsActive = True

            # print "** STARTING Datachecker"

            # dockwidget may not exist if:
            #    first run of plugin
            #    removed on close (see self.onClosePlugin method)
            if self.dockwidget == None:
                # Create the dockwidget (after translation) and keep reference
                self.dockwidget = DatacheckerDockWidget()
            databases = self.get_databases()
            self.dockwidget.bestaandeDatabases.addItems(databases)
            stylingfolders = self.get_stylingfolders()
            self.dockwidget.stylingbox.clear()
            self.dockwidget.stylingbox.addItems(stylingfolders)

            self.dockwidget.bestaandeDatabases.currentTextChanged.connect(
                self.getConnectionDetails
            )
            self.dockwidget.ObjectSlider.valueChanged.connect(self.slider_function)
            self.dockwidget.applyStylingButton.clicked.connect(self.laad_qml_styling)
            self.dockwidget.selectFolderButton.clicked.connect(self.pb_select_dc_folder)
            self.dockwidget.reloadResult.clicked.connect(self.fill_checks_list)
            self.dockwidget.outputFileButton.clicked.connect(self.select_output_file)
            self.dockwidget.folderNaam.textChanged.connect(self.save_folderchecks)
            self.dockwidget.folderNaam_export.textChanged.connect(
                self.save_folderbeheerexport
            )
            # self.dockwidget.folderNaam.editingFinished.connect(self.fill_checks_list)
            self.dockwidget.InladenGpkgButton.clicked.connect(self.laad_gpkg)
            self.dockwidget.savelayer.clicked.connect(self.save_qml_styling)

            self.dockwidget.addStyling.clicked.connect(self.add_qml_styling)
            self.dockwidget.removeStyling.clicked.connect(self.remove_qml_styling)
            self.dockwidget.selectFolderButton_export.clicked.connect(self.pb_select_exp_folder)
            self.dockwidget.createdbButton.clicked.connect(self.create_db_from_qgis)
            ##self.dockwidget.linePutten.dropevent.connect(over
            self.dockwidget.pgecontroleerd.clicked.connect(lambda:self.update_status(waarde ='gecontroleerd'))
            self.dockwidget.pverwerkt.clicked.connect(lambda:self.update_status(waarde ='verwerkt'))
            self.dockwidget.pleeg.clicked.connect(lambda:self.update_status(waarde = None))
            self.dockwidget.cbgecontroleerd.stateChanged.connect(lambda:self.filter_status(waarde ='gecontroleerd', filter = self.dockwidget.cbgecontroleerd.isChecked()))
            self.dockwidget.cbverwerkt.stateChanged.connect(lambda:self.filter_status(waarde ='verwerkt', filter = self.dockwidget.cbverwerkt.isChecked()))
            
            iface.currentLayerChanged.connect(lambda _: self.switch_visibility())
            # self.dockwidget.layerIsolate.stateChanged.connect(self.switch_layerIsolate)
            
            self.dockwidget.leidingFile.fileChanged.connect(self.save_leidingfile)
            self.dockwidget.putFile.fileChanged.connect(self.save_putfile)  
            self.dockwidget.dem.fileChanged.connect(self.save_DEMfile) 
            
            self.dockwidget.DatachecksButton.clicked.connect(self.draai_de_checks)
            
            try:
                self.dockwidget.boxSoftware.currentTextChanged.disconnect( self.importSoftware_opslaan)
            except:
                pass            
            self.dockwidget.boxSoftware.clear()
            self.dockwidget.boxSoftware.addItems(["gbi", "gisib"])
            self.dockwidget.boxSoftware.currentTextChanged.connect( self.importSoftware_opslaan)
            
            
            self.dockwidget.instellingenopslaan.clicked.connect(self.instellingenDefault_opslaan)
            
            for veld in velden:
                box = getattr(self.dockwidget, veld)
                box.valueChanged.connect(self.instellingen_opslaan)
                # waarde = box.valueChanged.connect(self.instellingen_opslaan)
            self.dockwidget.defaultInstellingen.clicked.connect(lambda:self.instellingen_laden(default=True))

            # connect to provide cleanup on closing of dockwidget
            self.dockwidget.closingPlugin.connect(self.onClosePlugin)

            # show the dockwidget
            # TODO: fix to allow choice of dock location
            self.iface.addDockWidget(Qt.RightDockWidgetArea, self.dockwidget)
            self.dockwidget.show()
            self.initialize_paths()
