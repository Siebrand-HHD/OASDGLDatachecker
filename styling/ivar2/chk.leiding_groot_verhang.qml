<!DOCTYPE qgis PUBLIC 'http://mrcc.com/qgis.dtd' 'SYSTEM'>
<qgis version="3.8.0-Zanzibar" labelsEnabled="0" styleCategories="AllStyleCategories" minScale="0" readOnly="0" hasScaleBasedVisibilityFlag="0" simplifyAlgorithm="0" simplifyDrawingHints="1" simplifyMaxScale="1" maxScale="0" simplifyDrawingTol="1" simplifyLocal="1">
  <flags>
    <Identifiable>1</Identifiable>
    <Removable>1</Removable>
    <Searchable>1</Searchable>
  </flags>
  <renderer-v2 type="singleSymbol" forceraster="0" enableorderby="0" symbollevels="0">
    <symbols>
      <symbol type="line" alpha="1" clip_to_extent="1" force_rhr="0" name="0">
        <layer pass="0" enabled="1" class="SimpleLine" locked="0">
          <prop v="square" k="capstyle"/>
          <prop v="5;2" k="customdash"/>
          <prop v="3x:0,0,0,0,0,0" k="customdash_map_unit_scale"/>
          <prop v="MM" k="customdash_unit"/>
          <prop v="0" k="draw_inside_polygon"/>
          <prop v="bevel" k="joinstyle"/>
          <prop v="84,255,5,255" k="line_color"/>
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
    <rotation/>
    <sizescale/>
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
    <field name="eindpunt">
      <editWidget type="">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="bob_beginpunt">
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
    <field name="hoogte_verschil_bob">
      <editWidget type="">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="lengte_leiding">
      <editWidget type="">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="verhang">
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
    <alias field="eindpunt" name="" index="4"/>
    <alias field="bob_beginpunt" name="" index="5"/>
    <alias field="bob_eindpunt" name="" index="6"/>
    <alias field="hoogte_verschil_bob" name="" index="7"/>
    <alias field="lengte_leiding" name="" index="8"/>
    <alias field="verhang" name="" index="9"/>
    <alias field="status" name="" index="10"/>
  </aliases>
  <excludeAttributesWMS/>
  <excludeAttributesWFS/>
  <defaults>
    <default field="id" applyOnUpdate="0" expression=""/>
    <default field="leiding" applyOnUpdate="0" expression=""/>
    <default field="threedi_id" applyOnUpdate="0" expression=""/>
    <default field="beginpunt" applyOnUpdate="0" expression=""/>
    <default field="eindpunt" applyOnUpdate="0" expression=""/>
    <default field="bob_beginpunt" applyOnUpdate="0" expression=""/>
    <default field="bob_eindpunt" applyOnUpdate="0" expression=""/>
    <default field="hoogte_verschil_bob" applyOnUpdate="0" expression=""/>
    <default field="lengte_leiding" applyOnUpdate="0" expression=""/>
    <default field="verhang" applyOnUpdate="0" expression=""/>
    <default field="status" applyOnUpdate="0" expression=""/>
  </defaults>
  <constraints>
    <constraint unique_strength="1" exp_strength="0" constraints="3" field="id" notnull_strength="1"/>
    <constraint unique_strength="0" exp_strength="0" constraints="0" field="leiding" notnull_strength="0"/>
    <constraint unique_strength="0" exp_strength="0" constraints="0" field="threedi_id" notnull_strength="0"/>
    <constraint unique_strength="0" exp_strength="0" constraints="0" field="beginpunt" notnull_strength="0"/>
    <constraint unique_strength="0" exp_strength="0" constraints="0" field="eindpunt" notnull_strength="0"/>
    <constraint unique_strength="0" exp_strength="0" constraints="0" field="bob_beginpunt" notnull_strength="0"/>
    <constraint unique_strength="0" exp_strength="0" constraints="0" field="bob_eindpunt" notnull_strength="0"/>
    <constraint unique_strength="0" exp_strength="0" constraints="0" field="hoogte_verschil_bob" notnull_strength="0"/>
    <constraint unique_strength="0" exp_strength="0" constraints="0" field="lengte_leiding" notnull_strength="0"/>
    <constraint unique_strength="0" exp_strength="0" constraints="0" field="verhang" notnull_strength="0"/>
    <constraint unique_strength="0" exp_strength="0" constraints="0" field="status" notnull_strength="0"/>
  </constraints>
  <constraintExpressions>
    <constraint desc="" exp="" field="id"/>
    <constraint desc="" exp="" field="leiding"/>
    <constraint desc="" exp="" field="threedi_id"/>
    <constraint desc="" exp="" field="beginpunt"/>
    <constraint desc="" exp="" field="eindpunt"/>
    <constraint desc="" exp="" field="bob_beginpunt"/>
    <constraint desc="" exp="" field="bob_eindpunt"/>
    <constraint desc="" exp="" field="hoogte_verschil_bob"/>
    <constraint desc="" exp="" field="lengte_leiding"/>
    <constraint desc="" exp="" field="verhang"/>
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
