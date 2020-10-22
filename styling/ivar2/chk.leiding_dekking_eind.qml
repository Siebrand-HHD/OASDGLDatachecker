<!DOCTYPE qgis PUBLIC 'http://mrcc.com/qgis.dtd' 'SYSTEM'>
<qgis version="3.8.0-Zanzibar" labelsEnabled="0" styleCategories="AllStyleCategories" minScale="0" readOnly="0" hasScaleBasedVisibilityFlag="0" simplifyAlgorithm="0" simplifyDrawingHints="1" simplifyMaxScale="1" maxScale="0" simplifyDrawingTol="1" simplifyLocal="1">
  <flags>
    <Identifiable>1</Identifiable>
    <Removable>1</Removable>
    <Searchable>1</Searchable>
  </flags>
  <renderer-v2 type="graduatedSymbol" forceraster="0" graduatedMethod="GraduatedColor" enableorderby="0" attr="if( &quot;dekking_put_maaiveldhoogte&quot; IS NULL, &quot;dekking_ahn_maaiveldhoogte&quot; , &quot;dekking_put_maaiveldhoogte&quot; )" symbollevels="0">
    <ranges>
      <range upper="0.000000000000000" symbol="0" label="leiding boven maaiveld" render="true" lower="-10.000000000000000"/>
      <range upper="0.200000000000000" symbol="1" label="leiding 0 tot 20cm onder maaiveld" render="true" lower="0.000000000000000"/>
      <range upper="0.400000000000000" symbol="2" label="leiding 20 tot 40cm onder maaiveld" render="true" lower="0.200000000000000"/>
      <range upper="0.600000000000000" symbol="3" label="leiding 40 tot 60cm onder maaiveld" render="true" lower="0.400000000000000"/>
      <range upper="0.800000000000000" symbol="4" label="leiding 60 tot 80cm onder maaiveld" render="true" lower="0.600000000000000"/>
    </ranges>
    <symbols>
      <symbol type="line" alpha="1" clip_to_extent="1" force_rhr="0" name="0">
        <layer pass="0" enabled="1" class="SimpleLine" locked="0">
          <prop v="square" k="capstyle"/>
          <prop v="5;2" k="customdash"/>
          <prop v="3x:0,0,0,0,0,0" k="customdash_map_unit_scale"/>
          <prop v="MM" k="customdash_unit"/>
          <prop v="0" k="draw_inside_polygon"/>
          <prop v="bevel" k="joinstyle"/>
          <prop v="103,0,13,255" k="line_color"/>
          <prop v="solid" k="line_style"/>
          <prop v="0.66" k="line_width"/>
          <prop v="MM" k="line_width_unit"/>
          <prop v="0" k="offset"/>
          <prop v="3x:0,0,0,0,0,0" k="offset_map_unit_scale"/>
          <prop v="MM" k="offset_unit"/>
          <prop v="0" k="ring_filter"/>
          <prop v="0" k="use_custom_dash"/>
          <prop v="3x:0,0,0,0,0,0" k="width_map_unit_scale"/>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" value="" name="name"/>
              <Option name="properties"/>
              <Option type="QString" value="collection" name="type"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol type="line" alpha="1" clip_to_extent="1" force_rhr="0" name="1">
        <layer pass="0" enabled="1" class="SimpleLine" locked="0">
          <prop v="square" k="capstyle"/>
          <prop v="5;2" k="customdash"/>
          <prop v="3x:0,0,0,0,0,0" k="customdash_map_unit_scale"/>
          <prop v="MM" k="customdash_unit"/>
          <prop v="0" k="draw_inside_polygon"/>
          <prop v="bevel" k="joinstyle"/>
          <prop v="212,32,32,255" k="line_color"/>
          <prop v="solid" k="line_style"/>
          <prop v="0.66" k="line_width"/>
          <prop v="MM" k="line_width_unit"/>
          <prop v="0" k="offset"/>
          <prop v="3x:0,0,0,0,0,0" k="offset_map_unit_scale"/>
          <prop v="MM" k="offset_unit"/>
          <prop v="0" k="ring_filter"/>
          <prop v="0" k="use_custom_dash"/>
          <prop v="3x:0,0,0,0,0,0" k="width_map_unit_scale"/>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" value="" name="name"/>
              <Option name="properties"/>
              <Option type="QString" value="collection" name="type"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol type="line" alpha="1" clip_to_extent="1" force_rhr="0" name="2">
        <layer pass="0" enabled="1" class="SimpleLine" locked="0">
          <prop v="square" k="capstyle"/>
          <prop v="5;2" k="customdash"/>
          <prop v="3x:0,0,0,0,0,0" k="customdash_map_unit_scale"/>
          <prop v="MM" k="customdash_unit"/>
          <prop v="0" k="draw_inside_polygon"/>
          <prop v="bevel" k="joinstyle"/>
          <prop v="252,112,80,255" k="line_color"/>
          <prop v="solid" k="line_style"/>
          <prop v="0.66" k="line_width"/>
          <prop v="MM" k="line_width_unit"/>
          <prop v="0" k="offset"/>
          <prop v="3x:0,0,0,0,0,0" k="offset_map_unit_scale"/>
          <prop v="MM" k="offset_unit"/>
          <prop v="0" k="ring_filter"/>
          <prop v="0" k="use_custom_dash"/>
          <prop v="3x:0,0,0,0,0,0" k="width_map_unit_scale"/>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" value="" name="name"/>
              <Option name="properties"/>
              <Option type="QString" value="collection" name="type"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol type="line" alpha="1" clip_to_extent="1" force_rhr="0" name="3">
        <layer pass="0" enabled="1" class="SimpleLine" locked="0">
          <prop v="square" k="capstyle"/>
          <prop v="5;2" k="customdash"/>
          <prop v="3x:0,0,0,0,0,0" k="customdash_map_unit_scale"/>
          <prop v="MM" k="customdash_unit"/>
          <prop v="0" k="draw_inside_polygon"/>
          <prop v="bevel" k="joinstyle"/>
          <prop v="253,190,165,255" k="line_color"/>
          <prop v="solid" k="line_style"/>
          <prop v="0.66" k="line_width"/>
          <prop v="MM" k="line_width_unit"/>
          <prop v="0" k="offset"/>
          <prop v="3x:0,0,0,0,0,0" k="offset_map_unit_scale"/>
          <prop v="MM" k="offset_unit"/>
          <prop v="0" k="ring_filter"/>
          <prop v="0" k="use_custom_dash"/>
          <prop v="3x:0,0,0,0,0,0" k="width_map_unit_scale"/>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" value="" name="name"/>
              <Option name="properties"/>
              <Option type="QString" value="collection" name="type"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol type="line" alpha="1" clip_to_extent="1" force_rhr="0" name="4">
        <layer pass="0" enabled="1" class="SimpleLine" locked="0">
          <prop v="square" k="capstyle"/>
          <prop v="5;2" k="customdash"/>
          <prop v="3x:0,0,0,0,0,0" k="customdash_map_unit_scale"/>
          <prop v="MM" k="customdash_unit"/>
          <prop v="0" k="draw_inside_polygon"/>
          <prop v="bevel" k="joinstyle"/>
          <prop v="255,245,240,255" k="line_color"/>
          <prop v="solid" k="line_style"/>
          <prop v="0.66" k="line_width"/>
          <prop v="MM" k="line_width_unit"/>
          <prop v="0" k="offset"/>
          <prop v="3x:0,0,0,0,0,0" k="offset_map_unit_scale"/>
          <prop v="MM" k="offset_unit"/>
          <prop v="0" k="ring_filter"/>
          <prop v="0" k="use_custom_dash"/>
          <prop v="3x:0,0,0,0,0,0" k="width_map_unit_scale"/>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" value="" name="name"/>
              <Option name="properties"/>
              <Option type="QString" value="collection" name="type"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
    </symbols>
    <source-symbol>
      <symbol type="line" alpha="1" clip_to_extent="1" force_rhr="0" name="0">
        <layer pass="0" enabled="1" class="SimpleLine" locked="0">
          <prop v="square" k="capstyle"/>
          <prop v="5;2" k="customdash"/>
          <prop v="3x:0,0,0,0,0,0" k="customdash_map_unit_scale"/>
          <prop v="MM" k="customdash_unit"/>
          <prop v="0" k="draw_inside_polygon"/>
          <prop v="bevel" k="joinstyle"/>
          <prop v="243,166,178,255" k="line_color"/>
          <prop v="solid" k="line_style"/>
          <prop v="0.26" k="line_width"/>
          <prop v="MM" k="line_width_unit"/>
          <prop v="0" k="offset"/>
          <prop v="3x:0,0,0,0,0,0" k="offset_map_unit_scale"/>
          <prop v="MM" k="offset_unit"/>
          <prop v="0" k="ring_filter"/>
          <prop v="0" k="use_custom_dash"/>
          <prop v="3x:0,0,0,0,0,0" k="width_map_unit_scale"/>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" value="" name="name"/>
              <Option name="properties"/>
              <Option type="QString" value="collection" name="type"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
    </source-symbol>
    <colorramp type="gradient" name="[source]">
      <prop v="103,0,13,255" k="color1"/>
      <prop v="255,245,240,255" k="color2"/>
      <prop v="0" k="discrete"/>
      <prop v="gradient" k="rampType"/>
      <prop v="0.1;165,15,21,255:0.22;203,24,29,255:0.35;239,59,44,255:0.48;251,106,74,255:0.61;252,146,114,255:0.74;252,187,161,255:0.87;254,224,210,255" k="stops"/>
    </colorramp>
    <mode name="equal"/>
    <symmetricMode enabled="false" symmetryPoint="0" astride="false"/>
    <rotation/>
    <sizescale/>
    <labelformat decimalplaces="2" trimtrailingzeroes="false" format="%1 - %2"/>
  </renderer-v2>
  <customproperties/>
  <blendMode>0</blendMode>
  <featureBlendMode>0</featureBlendMode>
  <layerOpacity>1</layerOpacity>
  <geometryOptions geometryPrecision="0" removeDuplicateNodes="0">
    <activeChecks/>
    <checkConfiguration/>
  </geometryOptions>
  <fieldConfiguration>
    <field name="id">
      <editWidget type="">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="leiding">
      <editWidget type="">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="threedi_id">
      <editWidget type="">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="beginpunt">
      <editWidget type="">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="bob_eindpunt">
      <editWidget type="">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="hoogte_profiel">
      <editWidget type="">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="bovenkant_leiding">
      <editWidget type="">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="put_maaiveldhoogte">
      <editWidget type="">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="ahn_maaiveldhoogte">
      <editWidget type="">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="dekking_put_maaiveldhoogte">
      <editWidget type="">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="dekking_ahn_maaiveldhoogte">
      <editWidget type="">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="status">
      <editWidget type="ValueMap">
        <config>
          <Option type="Map">
            <Option type="Map" name="map">
              <Option type="QString" value="gecontroleerd" name="gecontroleerd"/>
              <Option type="QString" value="verwerkt" name="verwerkt"/>
            </Option>
          </Option>
        </config>
      </editWidget>
    </field>
  </fieldConfiguration>
  <aliases>
    <alias field="id" name="" index="0"/>
    <alias field="leiding" name="" index="1"/>
    <alias field="threedi_id" name="" index="2"/>
    <alias field="beginpunt" name="" index="3"/>
    <alias field="bob_eindpunt" name="" index="4"/>
    <alias field="hoogte_profiel" name="" index="5"/>
    <alias field="bovenkant_leiding" name="" index="6"/>
    <alias field="put_maaiveldhoogte" name="" index="7"/>
    <alias field="ahn_maaiveldhoogte" name="" index="8"/>
    <alias field="dekking_put_maaiveldhoogte" name="" index="9"/>
    <alias field="dekking_ahn_maaiveldhoogte" name="" index="10"/>
    <alias field="status" name="" index="11"/>
  </aliases>
  <excludeAttributesWMS/>
  <excludeAttributesWFS/>
  <defaults>
    <default field="id" applyOnUpdate="0" expression=""/>
    <default field="leiding" applyOnUpdate="0" expression=""/>
    <default field="threedi_id" applyOnUpdate="0" expression=""/>
    <default field="beginpunt" applyOnUpdate="0" expression=""/>
    <default field="bob_eindpunt" applyOnUpdate="0" expression=""/>
    <default field="hoogte_profiel" applyOnUpdate="0" expression=""/>
    <default field="bovenkant_leiding" applyOnUpdate="0" expression=""/>
    <default field="put_maaiveldhoogte" applyOnUpdate="0" expression=""/>
    <default field="ahn_maaiveldhoogte" applyOnUpdate="0" expression=""/>
    <default field="dekking_put_maaiveldhoogte" applyOnUpdate="0" expression=""/>
    <default field="dekking_ahn_maaiveldhoogte" applyOnUpdate="0" expression=""/>
    <default field="status" applyOnUpdate="0" expression=""/>
  </defaults>
  <constraints>
    <constraint unique_strength="1" exp_strength="0" constraints="3" field="id" notnull_strength="1"/>
    <constraint unique_strength="0" exp_strength="0" constraints="0" field="leiding" notnull_strength="0"/>
    <constraint unique_strength="0" exp_strength="0" constraints="0" field="threedi_id" notnull_strength="0"/>
    <constraint unique_strength="0" exp_strength="0" constraints="0" field="beginpunt" notnull_strength="0"/>
    <constraint unique_strength="0" exp_strength="0" constraints="0" field="bob_eindpunt" notnull_strength="0"/>
    <constraint unique_strength="0" exp_strength="0" constraints="0" field="hoogte_profiel" notnull_strength="0"/>
    <constraint unique_strength="0" exp_strength="0" constraints="0" field="bovenkant_leiding" notnull_strength="0"/>
    <constraint unique_strength="0" exp_strength="0" constraints="0" field="put_maaiveldhoogte" notnull_strength="0"/>
    <constraint unique_strength="0" exp_strength="0" constraints="0" field="ahn_maaiveldhoogte" notnull_strength="0"/>
    <constraint unique_strength="0" exp_strength="0" constraints="0" field="dekking_put_maaiveldhoogte" notnull_strength="0"/>
    <constraint unique_strength="0" exp_strength="0" constraints="0" field="dekking_ahn_maaiveldhoogte" notnull_strength="0"/>
    <constraint unique_strength="0" exp_strength="0" constraints="0" field="status" notnull_strength="0"/>
  </constraints>
  <constraintExpressions>
    <constraint desc="" exp="" field="id"/>
    <constraint desc="" exp="" field="leiding"/>
    <constraint desc="" exp="" field="threedi_id"/>
    <constraint desc="" exp="" field="beginpunt"/>
    <constraint desc="" exp="" field="bob_eindpunt"/>
    <constraint desc="" exp="" field="hoogte_profiel"/>
    <constraint desc="" exp="" field="bovenkant_leiding"/>
    <constraint desc="" exp="" field="put_maaiveldhoogte"/>
    <constraint desc="" exp="" field="ahn_maaiveldhoogte"/>
    <constraint desc="" exp="" field="dekking_put_maaiveldhoogte"/>
    <constraint desc="" exp="" field="dekking_ahn_maaiveldhoogte"/>
    <constraint desc="" exp="" field="status"/>
  </constraintExpressions>
  <expressionfields/>
  <attributeactions/>
  <attributetableconfig sortOrder="0" sortExpression="" actionWidgetStyle="dropDown">
    <columns/>
  </attributetableconfig>
  <conditionalstyles>
    <rowstyles/>
    <fieldstyles/>
  </conditionalstyles>
  <editform tolerant="1"></editform>
  <editforminit/>
  <editforminitcodesource>0</editforminitcodesource>
  <editforminitfilepath></editforminitfilepath>
  <editforminitcode><![CDATA[]]></editforminitcode>
  <featformsuppress>0</featformsuppress>
  <editorlayout>generatedlayout</editorlayout>
  <editable/>
  <labelOnTop/>
  <widgets/>
  <previewExpression></previewExpression>
  <mapTip></mapTip>
  <layerGeometryType>1</layerGeometryType>
</qgis>
