<!DOCTYPE qgis PUBLIC 'http://mrcc.com/qgis.dtd' 'SYSTEM'>
<qgis hasScaleBasedVisibilityFlag="0" simplifyLocal="1" readOnly="0" simplifyDrawingHints="1" minScale="0" simplifyAlgorithm="0" version="3.8.0-Zanzibar" maxScale="0" labelsEnabled="0" styleCategories="AllStyleCategories" simplifyMaxScale="1" simplifyDrawingTol="1">
  <flags>
    <Identifiable>1</Identifiable>
    <Removable>1</Removable>
    <Searchable>1</Searchable>
  </flags>
  <renderer-v2 symbollevels="0" type="graduatedSymbol" graduatedMethod="GraduatedColor" enableorderby="0" attr="if( &quot;dekking_put_maaiveldhoogte&quot; IS NULL, &quot;dekking_ahn_maaiveldhoogte&quot; , &quot;dekking_put_maaiveldhoogte&quot; )" forceraster="0">
    <ranges>
      <range label="leiding boven maaiveld" render="true" upper="0.000000000000000" lower="-10.000000000000000" symbol="0"/>
      <range label="leiding 0 tot 20cm onder maaiveld" render="true" upper="0.200000000000000" lower="0.000000000000000" symbol="1"/>
      <range label="leiding 20 tot 40cm onder maaiveld" render="true" upper="0.400000000000000" lower="0.200000000000000" symbol="2"/>
      <range label="leiding 40 tot 60cm onder maaiveld" render="true" upper="0.600000000000000" lower="0.400000000000000" symbol="3"/>
      <range label="leiding 60 tot 80cm onder maaiveld" render="true" upper="0.800000000000000" lower="0.600000000000000" symbol="4"/>
    </ranges>
    <symbols>
      <symbol clip_to_extent="1" type="line" name="0" force_rhr="0" alpha="1">
        <layer enabled="1" class="SimpleLine" locked="0" pass="0">
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
              <Option type="QString" name="name" value=""/>
              <Option name="properties"/>
              <Option type="QString" name="type" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol clip_to_extent="1" type="line" name="1" force_rhr="0" alpha="1">
        <layer enabled="1" class="SimpleLine" locked="0" pass="0">
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
              <Option type="QString" name="name" value=""/>
              <Option name="properties"/>
              <Option type="QString" name="type" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol clip_to_extent="1" type="line" name="2" force_rhr="0" alpha="1">
        <layer enabled="1" class="SimpleLine" locked="0" pass="0">
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
              <Option type="QString" name="name" value=""/>
              <Option name="properties"/>
              <Option type="QString" name="type" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol clip_to_extent="1" type="line" name="3" force_rhr="0" alpha="1">
        <layer enabled="1" class="SimpleLine" locked="0" pass="0">
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
              <Option type="QString" name="name" value=""/>
              <Option name="properties"/>
              <Option type="QString" name="type" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol clip_to_extent="1" type="line" name="4" force_rhr="0" alpha="1">
        <layer enabled="1" class="SimpleLine" locked="0" pass="0">
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
              <Option type="QString" name="name" value=""/>
              <Option name="properties"/>
              <Option type="QString" name="type" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
    </symbols>
    <source-symbol>
      <symbol clip_to_extent="1" type="line" name="0" force_rhr="0" alpha="1">
        <layer enabled="1" class="SimpleLine" locked="0" pass="0">
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
              <Option type="QString" name="name" value=""/>
              <Option name="properties"/>
              <Option type="QString" name="type" value="collection"/>
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
    <symmetricMode symmetryPoint="0" enabled="false" astride="false"/>
    <rotation/>
    <sizescale/>
    <labelformat format="%1 - %2" decimalplaces="2" trimtrailingzeroes="false"/>
  </renderer-v2>
  <customproperties/>
  <blendMode>0</blendMode>
  <featureBlendMode>0</featureBlendMode>
  <layerOpacity>1</layerOpacity>
  <geometryOptions removeDuplicateNodes="0" geometryPrecision="0">
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
              <Option type="QString" name="gecontroleerd" value="gecontroleerd"/>
              <Option type="QString" name="verwerkt" value="verwerkt"/>
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
    <constraint field="id" notnull_strength="1" constraints="3" exp_strength="0" unique_strength="1"/>
    <constraint field="leiding" notnull_strength="0" constraints="0" exp_strength="0" unique_strength="0"/>
    <constraint field="threedi_id" notnull_strength="0" constraints="0" exp_strength="0" unique_strength="0"/>
    <constraint field="beginpunt" notnull_strength="0" constraints="0" exp_strength="0" unique_strength="0"/>
    <constraint field="bob_eindpunt" notnull_strength="0" constraints="0" exp_strength="0" unique_strength="0"/>
    <constraint field="hoogte_profiel" notnull_strength="0" constraints="0" exp_strength="0" unique_strength="0"/>
    <constraint field="bovenkant_leiding" notnull_strength="0" constraints="0" exp_strength="0" unique_strength="0"/>
    <constraint field="put_maaiveldhoogte" notnull_strength="0" constraints="0" exp_strength="0" unique_strength="0"/>
    <constraint field="ahn_maaiveldhoogte" notnull_strength="0" constraints="0" exp_strength="0" unique_strength="0"/>
    <constraint field="dekking_put_maaiveldhoogte" notnull_strength="0" constraints="0" exp_strength="0" unique_strength="0"/>
    <constraint field="dekking_ahn_maaiveldhoogte" notnull_strength="0" constraints="0" exp_strength="0" unique_strength="0"/>
    <constraint field="status" notnull_strength="0" constraints="0" exp_strength="0" unique_strength="0"/>
  </constraints>
  <constraintExpressions>
    <constraint field="id" exp="" desc=""/>
    <constraint field="leiding" exp="" desc=""/>
    <constraint field="threedi_id" exp="" desc=""/>
    <constraint field="beginpunt" exp="" desc=""/>
    <constraint field="bob_eindpunt" exp="" desc=""/>
    <constraint field="hoogte_profiel" exp="" desc=""/>
    <constraint field="bovenkant_leiding" exp="" desc=""/>
    <constraint field="put_maaiveldhoogte" exp="" desc=""/>
    <constraint field="ahn_maaiveldhoogte" exp="" desc=""/>
    <constraint field="dekking_put_maaiveldhoogte" exp="" desc=""/>
    <constraint field="dekking_ahn_maaiveldhoogte" exp="" desc=""/>
    <constraint field="status" exp="" desc=""/>
  </constraintExpressions>
  <expressionfields/>
  <attributeactions/>
  <attributetableconfig sortExpression="" actionWidgetStyle="dropDown" sortOrder="0">
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
