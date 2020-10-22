<!DOCTYPE qgis PUBLIC 'http://mrcc.com/qgis.dtd' 'SYSTEM'>
<qgis labelsEnabled="0" simplifyDrawingHints="0" maxScale="0" simplifyAlgorithm="0" styleCategories="AllStyleCategories" hasScaleBasedVisibilityFlag="0" simplifyDrawingTol="1" simplifyMaxScale="1" minScale="0" version="3.8.0-Zanzibar" simplifyLocal="1" readOnly="0">
  <flags>
    <Identifiable>1</Identifiable>
    <Removable>1</Removable>
    <Searchable>1</Searchable>
  </flags>
  <renderer-v2 symbollevels="0" enableorderby="0" forceraster="0" type="singleSymbol">
    <symbols>
      <symbol name="0" force_rhr="0" clip_to_extent="1" alpha="1" type="marker">
        <layer pass="0" locked="0" class="SimpleMarker" enabled="1">
          <prop k="angle" v="0"/>
          <prop k="color" v="219,30,42,255"/>
          <prop k="horizontal_anchor_point" v="1"/>
          <prop k="joinstyle" v="bevel"/>
          <prop k="name" v="circle"/>
          <prop k="offset" v="0,0"/>
          <prop k="offset_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="offset_unit" v="MM"/>
          <prop k="outline_color" v="128,17,25,255"/>
          <prop k="outline_style" v="solid"/>
          <prop k="outline_width" v="0.4"/>
          <prop k="outline_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="outline_width_unit" v="MM"/>
          <prop k="scale_method" v="diameter"/>
          <prop k="size" v="4"/>
          <prop k="size_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="size_unit" v="MM"/>
          <prop k="vertical_anchor_point" v="1"/>
          <data_defined_properties>
            <Option type="Map">
              <Option name="name" type="QString" value=""/>
              <Option name="properties"/>
              <Option name="type" type="QString" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
    </symbols>
    <rotation/>
    <sizescale/>
  </renderer-v2>
  <customproperties>
    <property key="embeddedWidgets/count" value="0"/>
    <property key="variableNames"/>
    <property key="variableValues"/>
  </customproperties>
  <blendMode>0</blendMode>
  <featureBlendMode>0</featureBlendMode>
  <layerOpacity>1</layerOpacity>
  <SingleCategoryDiagramRenderer diagramType="Histogram" attributeLegend="1">
    <DiagramCategory width="15" backgroundColor="#ffffff" backgroundAlpha="255" opacity="1" scaleBasedVisibility="0" enabled="0" scaleDependency="Area" barWidth="5" rotationOffset="270" sizeScale="3x:0,0,0,0,0,0" lineSizeType="MM" lineSizeScale="3x:0,0,0,0,0,0" minimumSize="0" penWidth="0" height="15" penColor="#000000" diagramOrientation="Up" maxScaleDenominator="0" penAlpha="255" minScaleDenominator="0" labelPlacementMethod="XHeight" sizeType="MM">
      <fontProperties description="MS Shell Dlg 2,8.14286,-1,5,50,0,0,0,0,0" style=""/>
    </DiagramCategory>
  </SingleCategoryDiagramRenderer>
  <DiagramLayerSettings zIndex="0" dist="0" linePlacementFlags="18" showAll="1" priority="0" obstacle="0" placement="0">
    <properties>
      <Option type="Map">
        <Option name="name" type="QString" value=""/>
        <Option name="properties"/>
        <Option name="type" type="QString" value="collection"/>
      </Option>
    </properties>
  </DiagramLayerSettings>
  <geometryOptions geometryPrecision="0" removeDuplicateNodes="0">
    <activeChecks/>
    <checkConfiguration/>
  </geometryOptions>
  <fieldConfiguration>
    <field name="id">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="rioolput">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="threedi_id">
      <editWidget type="Range">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="status">
      <editWidget type="ValueMap">
        <config>
          <Option type="Map">
            <Option name="map" type="Map">
              <Option name="gecontroleerd" type="QString" value="gecontroleerd"/>
              <Option name="verwerkt" type="QString" value="verwerkt"/>
            </Option>
          </Option>
        </config>
      </editWidget>
    </field>
  </fieldConfiguration>
  <aliases>
    <alias name="" field="id" index="0"/>
    <alias name="" field="rioolput" index="1"/>
    <alias name="" field="threedi_id" index="2"/>
    <alias name="" field="status" index="3"/>
  </aliases>
  <excludeAttributesWMS/>
  <excludeAttributesWFS/>
  <defaults>
    <default field="id" applyOnUpdate="0" expression=""/>
    <default field="rioolput" applyOnUpdate="0" expression=""/>
    <default field="threedi_id" applyOnUpdate="0" expression=""/>
    <default field="status" applyOnUpdate="0" expression=""/>
  </defaults>
  <constraints>
    <constraint field="id" constraints="3" exp_strength="0" unique_strength="1" notnull_strength="1"/>
    <constraint field="rioolput" constraints="0" exp_strength="0" unique_strength="0" notnull_strength="0"/>
    <constraint field="threedi_id" constraints="0" exp_strength="0" unique_strength="0" notnull_strength="0"/>
    <constraint field="status" constraints="0" exp_strength="0" unique_strength="0" notnull_strength="0"/>
  </constraints>
  <constraintExpressions>
    <constraint exp="" field="id" desc=""/>
    <constraint exp="" field="rioolput" desc=""/>
    <constraint exp="" field="threedi_id" desc=""/>
    <constraint exp="" field="status" desc=""/>
  </constraintExpressions>
  <expressionfields/>
  <attributeactions>
    <defaultAction key="Canvas" value="{00000000-0000-0000-0000-000000000000}"/>
  </attributeactions>
  <attributetableconfig actionWidgetStyle="dropDown" sortOrder="0" sortExpression="">
    <columns>
      <column name="id" width="-1" hidden="0" type="field"/>
      <column name="rioolput" width="-1" hidden="0" type="field"/>
      <column name="threedi_id" width="-1" hidden="0" type="field"/>
      <column name="status" width="-1" hidden="0" type="field"/>
      <column width="-1" hidden="1" type="actions"/>
    </columns>
  </attributetableconfig>
  <conditionalstyles>
    <rowstyles/>
    <fieldstyles/>
  </conditionalstyles>
  <editform tolerant="1"></editform>
  <editforminit/>
  <editforminitcodesource>0</editforminitcodesource>
  <editforminitfilepath></editforminitfilepath>
  <editforminitcode><![CDATA[# -*- coding: utf-8 -*-
"""
Formulieren van QGIS kunnen een functie voor Python hebben die wordt aangeroepen wanneer het formulier wordt geopend.

Gebruik deze functie om extra logica aan uw formulieren toe te voegen.

Voer de naam van de functie in in het veld "Python Init function".

Een voorbeeld volgt hieronder:
"""
from qgis.PyQt.QtWidgets import QWidget

def my_form_open(dialog, layer, feature):
	geom = feature.geometry()
	control = dialog.findChild(QWidget, "MyLineEdit")
]]></editforminitcode>
  <featformsuppress>0</featformsuppress>
  <editorlayout>generatedlayout</editorlayout>
  <editable>
    <field name="id" editable="1"/>
    <field name="rioolput" editable="1"/>
    <field name="status" editable="1"/>
    <field name="threedi_id" editable="1"/>
  </editable>
  <labelOnTop>
    <field name="id" labelOnTop="0"/>
    <field name="rioolput" labelOnTop="0"/>
    <field name="status" labelOnTop="0"/>
    <field name="threedi_id" labelOnTop="0"/>
  </labelOnTop>
  <widgets/>
  <previewExpression>id</previewExpression>
  <mapTip></mapTip>
  <layerGeometryType>0</layerGeometryType>
</qgis>
