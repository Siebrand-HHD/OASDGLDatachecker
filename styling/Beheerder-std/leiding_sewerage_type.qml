<!DOCTYPE qgis PUBLIC 'http://mrcc.com/qgis.dtd' 'SYSTEM'>
<qgis simplifyMaxScale="1" hasScaleBasedVisibilityFlag="0" minScale="1e+08" simplifyAlgorithm="0" maxScale="0" version="3.8.0-Zanzibar" readOnly="0" styleCategories="AllStyleCategories" labelsEnabled="0" simplifyDrawingTol="1" simplifyDrawingHints="1" simplifyLocal="1">
  <flags>
    <Identifiable>1</Identifiable>
    <Removable>1</Removable>
    <Searchable>1</Searchable>
  </flags>
  <renderer-v2 forceraster="0" enableorderby="0" type="singleSymbol" symbollevels="0">
    <symbols>
      <symbol name="0" type="line" force_rhr="0" clip_to_extent="1" alpha="1">
        <layer class="SimpleLine" pass="0" enabled="1" locked="0">
          <prop v="square" k="capstyle"/>
          <prop v="5;2" k="customdash"/>
          <prop v="3x:0,0,0,0,0,0" k="customdash_map_unit_scale"/>
          <prop v="MM" k="customdash_unit"/>
          <prop v="0" k="draw_inside_polygon"/>
          <prop v="bevel" k="joinstyle"/>
          <prop v="190,40,180,255" k="line_color"/>
          <prop v="solid" k="line_style"/>
          <prop v="1.46" k="line_width"/>
          <prop v="MM" k="line_width_unit"/>
          <prop v="0" k="offset"/>
          <prop v="3x:0,0,0,0,0,0" k="offset_map_unit_scale"/>
          <prop v="MM" k="offset_unit"/>
          <prop v="0" k="ring_filter"/>
          <prop v="0" k="use_custom_dash"/>
          <prop v="3x:0,0,0,0,0,0" k="width_map_unit_scale"/>
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
    <property value="true" key="ShowFeatureCount"/>
    <property value="0" key="embeddedWidgets/count"/>
    <property key="variableNames"/>
    <property key="variableValues"/>
  </customproperties>
  <blendMode>0</blendMode>
  <featureBlendMode>0</featureBlendMode>
  <layerOpacity>1</layerOpacity>
  <SingleCategoryDiagramRenderer diagramType="Histogram" attributeLegend="1">
    <DiagramCategory rotationOffset="270" height="15" barWidth="5" lineSizeScale="3x:0,0,0,0,0,0" minimumSize="0" width="15" penWidth="0" labelPlacementMethod="XHeight" penAlpha="255" backgroundAlpha="255" penColor="#000000" lineSizeType="MM" enabled="0" diagramOrientation="Up" sizeScale="3x:0,0,0,0,0,0" maxScaleDenominator="1e+08" minScaleDenominator="0" sizeType="MM" scaleBasedVisibility="0" opacity="1" scaleDependency="Area" backgroundColor="#ffffff">
      <fontProperties description="MS Shell Dlg 2,7.875,-1,5,50,0,0,0,0,0" style=""/>
      <attribute color="#000000" label="" field=""/>
    </DiagramCategory>
  </SingleCategoryDiagramRenderer>
  <DiagramLayerSettings showAll="1" placement="2" linePlacementFlags="18" zIndex="0" priority="0" dist="0" obstacle="0">
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
    <field name="pipe_sewerage_type">
      <editWidget type="Range">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="pipe_cross_section_definition_id">
      <editWidget type="Range">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="pipe_material">
      <editWidget type="Range">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="pipe_display_name">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="pipe_calculation_type">
      <editWidget type="Range">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="pipe_invert_level_start_point">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="pipe_invert_level_end_point">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="pipe_zoom_category">
      <editWidget type="Range">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="pipe_id">
      <editWidget type="Range">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="pipe_code">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="pipe_profile_num">
      <editWidget type="Range">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="pipe_friction_value">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="pipe_friction_type">
      <editWidget type="Range">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="pipe_dist_calc_points">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="pipe_original_length">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="pipe_connection_node_start_id">
      <editWidget type="Range">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="pipe_connection_node_end_id">
      <editWidget type="Range">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="def_id">
      <editWidget type="Range">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="def_shape">
      <editWidget type="Range">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="def_width">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="def_height">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="def_code">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
  </fieldConfiguration>
  <aliases>
    <alias name="" index="0" field="id"/>
    <alias name="" index="1" field="pipe_sewerage_type"/>
    <alias name="" index="2" field="pipe_cross_section_definition_id"/>
    <alias name="" index="3" field="pipe_material"/>
    <alias name="" index="4" field="pipe_display_name"/>
    <alias name="" index="5" field="pipe_calculation_type"/>
    <alias name="" index="6" field="pipe_invert_level_start_point"/>
    <alias name="" index="7" field="pipe_invert_level_end_point"/>
    <alias name="" index="8" field="pipe_zoom_category"/>
    <alias name="" index="9" field="pipe_id"/>
    <alias name="" index="10" field="pipe_code"/>
    <alias name="" index="11" field="pipe_profile_num"/>
    <alias name="" index="12" field="pipe_friction_value"/>
    <alias name="" index="13" field="pipe_friction_type"/>
    <alias name="" index="14" field="pipe_dist_calc_points"/>
    <alias name="" index="15" field="pipe_original_length"/>
    <alias name="" index="16" field="pipe_connection_node_start_id"/>
    <alias name="" index="17" field="pipe_connection_node_end_id"/>
    <alias name="" index="18" field="def_id"/>
    <alias name="" index="19" field="def_shape"/>
    <alias name="" index="20" field="def_width"/>
    <alias name="" index="21" field="def_height"/>
    <alias name="" index="22" field="def_code"/>
  </aliases>
  <excludeAttributesWMS/>
  <excludeAttributesWFS/>
  <defaults>
    <default expression="" applyOnUpdate="0" field="id"/>
    <default expression="" applyOnUpdate="0" field="pipe_sewerage_type"/>
    <default expression="" applyOnUpdate="0" field="pipe_cross_section_definition_id"/>
    <default expression="" applyOnUpdate="0" field="pipe_material"/>
    <default expression="" applyOnUpdate="0" field="pipe_display_name"/>
    <default expression="" applyOnUpdate="0" field="pipe_calculation_type"/>
    <default expression="" applyOnUpdate="0" field="pipe_invert_level_start_point"/>
    <default expression="" applyOnUpdate="0" field="pipe_invert_level_end_point"/>
    <default expression="" applyOnUpdate="0" field="pipe_zoom_category"/>
    <default expression="" applyOnUpdate="0" field="pipe_id"/>
    <default expression="" applyOnUpdate="0" field="pipe_code"/>
    <default expression="" applyOnUpdate="0" field="pipe_profile_num"/>
    <default expression="" applyOnUpdate="0" field="pipe_friction_value"/>
    <default expression="" applyOnUpdate="0" field="pipe_friction_type"/>
    <default expression="" applyOnUpdate="0" field="pipe_dist_calc_points"/>
    <default expression="" applyOnUpdate="0" field="pipe_original_length"/>
    <default expression="" applyOnUpdate="0" field="pipe_connection_node_start_id"/>
    <default expression="" applyOnUpdate="0" field="pipe_connection_node_end_id"/>
    <default expression="" applyOnUpdate="0" field="def_id"/>
    <default expression="" applyOnUpdate="0" field="def_shape"/>
    <default expression="" applyOnUpdate="0" field="def_width"/>
    <default expression="" applyOnUpdate="0" field="def_height"/>
    <default expression="" applyOnUpdate="0" field="def_code"/>
  </defaults>
  <constraints>
    <constraint constraints="3" unique_strength="1" notnull_strength="1" field="id" exp_strength="0"/>
    <constraint constraints="0" unique_strength="0" notnull_strength="0" field="pipe_sewerage_type" exp_strength="0"/>
    <constraint constraints="0" unique_strength="0" notnull_strength="0" field="pipe_cross_section_definition_id" exp_strength="0"/>
    <constraint constraints="0" unique_strength="0" notnull_strength="0" field="pipe_material" exp_strength="0"/>
    <constraint constraints="0" unique_strength="0" notnull_strength="0" field="pipe_display_name" exp_strength="0"/>
    <constraint constraints="0" unique_strength="0" notnull_strength="0" field="pipe_calculation_type" exp_strength="0"/>
    <constraint constraints="0" unique_strength="0" notnull_strength="0" field="pipe_invert_level_start_point" exp_strength="0"/>
    <constraint constraints="0" unique_strength="0" notnull_strength="0" field="pipe_invert_level_end_point" exp_strength="0"/>
    <constraint constraints="0" unique_strength="0" notnull_strength="0" field="pipe_zoom_category" exp_strength="0"/>
    <constraint constraints="0" unique_strength="0" notnull_strength="0" field="pipe_id" exp_strength="0"/>
    <constraint constraints="0" unique_strength="0" notnull_strength="0" field="pipe_code" exp_strength="0"/>
    <constraint constraints="0" unique_strength="0" notnull_strength="0" field="pipe_profile_num" exp_strength="0"/>
    <constraint constraints="0" unique_strength="0" notnull_strength="0" field="pipe_friction_value" exp_strength="0"/>
    <constraint constraints="0" unique_strength="0" notnull_strength="0" field="pipe_friction_type" exp_strength="0"/>
    <constraint constraints="0" unique_strength="0" notnull_strength="0" field="pipe_dist_calc_points" exp_strength="0"/>
    <constraint constraints="0" unique_strength="0" notnull_strength="0" field="pipe_original_length" exp_strength="0"/>
    <constraint constraints="0" unique_strength="0" notnull_strength="0" field="pipe_connection_node_start_id" exp_strength="0"/>
    <constraint constraints="0" unique_strength="0" notnull_strength="0" field="pipe_connection_node_end_id" exp_strength="0"/>
    <constraint constraints="0" unique_strength="0" notnull_strength="0" field="def_id" exp_strength="0"/>
    <constraint constraints="0" unique_strength="0" notnull_strength="0" field="def_shape" exp_strength="0"/>
    <constraint constraints="0" unique_strength="0" notnull_strength="0" field="def_width" exp_strength="0"/>
    <constraint constraints="0" unique_strength="0" notnull_strength="0" field="def_height" exp_strength="0"/>
    <constraint constraints="0" unique_strength="0" notnull_strength="0" field="def_code" exp_strength="0"/>
  </constraints>
  <constraintExpressions>
    <constraint field="id" exp="" desc=""/>
    <constraint field="pipe_sewerage_type" exp="" desc=""/>
    <constraint field="pipe_cross_section_definition_id" exp="" desc=""/>
    <constraint field="pipe_material" exp="" desc=""/>
    <constraint field="pipe_display_name" exp="" desc=""/>
    <constraint field="pipe_calculation_type" exp="" desc=""/>
    <constraint field="pipe_invert_level_start_point" exp="" desc=""/>
    <constraint field="pipe_invert_level_end_point" exp="" desc=""/>
    <constraint field="pipe_zoom_category" exp="" desc=""/>
    <constraint field="pipe_id" exp="" desc=""/>
    <constraint field="pipe_code" exp="" desc=""/>
    <constraint field="pipe_profile_num" exp="" desc=""/>
    <constraint field="pipe_friction_value" exp="" desc=""/>
    <constraint field="pipe_friction_type" exp="" desc=""/>
    <constraint field="pipe_dist_calc_points" exp="" desc=""/>
    <constraint field="pipe_original_length" exp="" desc=""/>
    <constraint field="pipe_connection_node_start_id" exp="" desc=""/>
    <constraint field="pipe_connection_node_end_id" exp="" desc=""/>
    <constraint field="def_id" exp="" desc=""/>
    <constraint field="def_shape" exp="" desc=""/>
    <constraint field="def_width" exp="" desc=""/>
    <constraint field="def_height" exp="" desc=""/>
    <constraint field="def_code" exp="" desc=""/>
  </constraintExpressions>
  <expressionfields/>
  <attributeactions>
    <defaultAction value="{00000000-0000-0000-0000-000000000000}" key="Canvas"/>
  </attributeactions>
  <attributetableconfig actionWidgetStyle="dropDown" sortOrder="0" sortExpression="">
    <columns>
      <column width="-1" name="id" type="field" hidden="0"/>
      <column width="-1" name="pipe_sewerage_type" type="field" hidden="0"/>
      <column width="-1" name="pipe_cross_section_definition_id" type="field" hidden="0"/>
      <column width="-1" name="pipe_material" type="field" hidden="0"/>
      <column width="-1" name="pipe_display_name" type="field" hidden="0"/>
      <column width="-1" name="pipe_calculation_type" type="field" hidden="0"/>
      <column width="-1" name="pipe_invert_level_start_point" type="field" hidden="0"/>
      <column width="-1" name="pipe_invert_level_end_point" type="field" hidden="0"/>
      <column width="-1" name="pipe_zoom_category" type="field" hidden="0"/>
      <column width="-1" name="pipe_id" type="field" hidden="0"/>
      <column width="-1" name="pipe_code" type="field" hidden="0"/>
      <column width="-1" name="pipe_profile_num" type="field" hidden="0"/>
      <column width="-1" name="pipe_friction_value" type="field" hidden="0"/>
      <column width="-1" name="pipe_friction_type" type="field" hidden="0"/>
      <column width="-1" name="pipe_dist_calc_points" type="field" hidden="0"/>
      <column width="-1" name="pipe_original_length" type="field" hidden="0"/>
      <column width="-1" name="pipe_connection_node_start_id" type="field" hidden="0"/>
      <column width="-1" name="pipe_connection_node_end_id" type="field" hidden="0"/>
      <column width="-1" name="def_id" type="field" hidden="0"/>
      <column width="-1" name="def_shape" type="field" hidden="0"/>
      <column width="-1" name="def_width" type="field" hidden="0"/>
      <column width="-1" name="def_height" type="field" hidden="0"/>
      <column width="-1" name="def_code" type="field" hidden="0"/>
      <column width="-1" type="actions" hidden="1"/>
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
    <field name="def_code" editable="1"/>
    <field name="def_height" editable="1"/>
    <field name="def_id" editable="1"/>
    <field name="def_shape" editable="1"/>
    <field name="def_width" editable="1"/>
    <field name="id" editable="1"/>
    <field name="pipe_calculation_type" editable="1"/>
    <field name="pipe_code" editable="1"/>
    <field name="pipe_connection_node_end_id" editable="1"/>
    <field name="pipe_connection_node_start_id" editable="1"/>
    <field name="pipe_cross_section_definition_id" editable="1"/>
    <field name="pipe_display_name" editable="1"/>
    <field name="pipe_dist_calc_points" editable="1"/>
    <field name="pipe_friction_type" editable="1"/>
    <field name="pipe_friction_value" editable="1"/>
    <field name="pipe_id" editable="1"/>
    <field name="pipe_invert_level_end_point" editable="1"/>
    <field name="pipe_invert_level_start_point" editable="1"/>
    <field name="pipe_material" editable="1"/>
    <field name="pipe_original_length" editable="1"/>
    <field name="pipe_profile_num" editable="1"/>
    <field name="pipe_sewerage_type" editable="1"/>
    <field name="pipe_zoom_category" editable="1"/>
  </editable>
  <labelOnTop>
    <field labelOnTop="0" name="def_code"/>
    <field labelOnTop="0" name="def_height"/>
    <field labelOnTop="0" name="def_id"/>
    <field labelOnTop="0" name="def_shape"/>
    <field labelOnTop="0" name="def_width"/>
    <field labelOnTop="0" name="id"/>
    <field labelOnTop="0" name="pipe_calculation_type"/>
    <field labelOnTop="0" name="pipe_code"/>
    <field labelOnTop="0" name="pipe_connection_node_end_id"/>
    <field labelOnTop="0" name="pipe_connection_node_start_id"/>
    <field labelOnTop="0" name="pipe_cross_section_definition_id"/>
    <field labelOnTop="0" name="pipe_display_name"/>
    <field labelOnTop="0" name="pipe_dist_calc_points"/>
    <field labelOnTop="0" name="pipe_friction_type"/>
    <field labelOnTop="0" name="pipe_friction_value"/>
    <field labelOnTop="0" name="pipe_id"/>
    <field labelOnTop="0" name="pipe_invert_level_end_point"/>
    <field labelOnTop="0" name="pipe_invert_level_start_point"/>
    <field labelOnTop="0" name="pipe_material"/>
    <field labelOnTop="0" name="pipe_original_length"/>
    <field labelOnTop="0" name="pipe_profile_num"/>
    <field labelOnTop="0" name="pipe_sewerage_type"/>
    <field labelOnTop="0" name="pipe_zoom_category"/>
  </labelOnTop>
  <widgets/>
  <previewExpression>pipe_display_name</previewExpression>
  <mapTip></mapTip>
  <layerGeometryType>1</layerGeometryType>
</qgis>
