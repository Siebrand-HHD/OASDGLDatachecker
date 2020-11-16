<!DOCTYPE qgis PUBLIC 'http://mrcc.com/qgis.dtd' 'SYSTEM'>
<qgis version="3.8.0-Zanzibar" labelsEnabled="0" styleCategories="AllStyleCategories" minScale="0" readOnly="0" hasScaleBasedVisibilityFlag="0" simplifyAlgorithm="0" simplifyDrawingHints="1" simplifyMaxScale="1" maxScale="0" simplifyDrawingTol="1" simplifyLocal="1">
  <flags>
    <Identifiable>1</Identifiable>
    <Removable>1</Removable>
    <Searchable>1</Searchable>
  </flags>
  <renderer-v2 type="RuleRenderer" forceraster="0" enableorderby="0" symbollevels="0">
    <rules key="{5fb80366-4c16-4a1f-9f5d-fa85c5647e61}">
      <rule filter=" &quot;grootste_put_afmeting&quot; &lt; &quot;breedte_leiding&quot;  AND  &quot;grootste_put_afmeting&quot; > 0" key="{4534d29c-9011-459b-b072-bc84074229da}" symbol="0" label="leidingafmeting is groter dan putafmeting"/>
      <rule filter="grootste_put_afmeting >= breedte_leiding" key="{0a36857d-96d6-4bf2-a510-7d2e86891069}" symbol="1" label="leidingbreedte + buffer is groter is dan de putafmeting"/>
    </rules>
    <symbols>
      <symbol type="marker" alpha="1" clip_to_extent="1" force_rhr="0" name="0">
        <layer pass="0" enabled="1" class="SimpleMarker" locked="0">
          <prop v="0" k="angle"/>
          <prop v="48,193,0,255" k="color"/>
          <prop v="1" k="horizontal_anchor_point"/>
          <prop v="bevel" k="joinstyle"/>
          <prop v="circle" k="name"/>
          <prop v="0,0" k="offset"/>
          <prop v="3x:0,0,0,0,0,0" k="offset_map_unit_scale"/>
          <prop v="MM" k="offset_unit"/>
          <prop v="35,35,35,255" k="outline_color"/>
          <prop v="solid" k="outline_style"/>
          <prop v="0" k="outline_width"/>
          <prop v="3x:0,0,0,0,0,0" k="outline_width_map_unit_scale"/>
          <prop v="MM" k="outline_width_unit"/>
          <prop v="diameter" k="scale_method"/>
          <prop v="2" k="size"/>
          <prop v="3x:0,0,0,0,0,0" k="size_map_unit_scale"/>
          <prop v="MM" k="size_unit"/>
          <prop v="1" k="vertical_anchor_point"/>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" value="" name="name"/>
              <Option name="properties"/>
              <Option type="QString" value="collection" name="type"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol type="marker" alpha="1" clip_to_extent="1" force_rhr="0" name="1">
        <layer pass="0" enabled="1" class="SimpleMarker" locked="0">
          <prop v="0" k="angle"/>
          <prop v="203,230,183,255" k="color"/>
          <prop v="1" k="horizontal_anchor_point"/>
          <prop v="bevel" k="joinstyle"/>
          <prop v="circle" k="name"/>
          <prop v="0,0" k="offset"/>
          <prop v="3x:0,0,0,0,0,0" k="offset_map_unit_scale"/>
          <prop v="MM" k="offset_unit"/>
          <prop v="35,35,35,255" k="outline_color"/>
          <prop v="solid" k="outline_style"/>
          <prop v="0" k="outline_width"/>
          <prop v="3x:0,0,0,0,0,0" k="outline_width_map_unit_scale"/>
          <prop v="MM" k="outline_width_unit"/>
          <prop v="diameter" k="scale_method"/>
          <prop v="2" k="size"/>
          <prop v="3x:0,0,0,0,0,0" k="size_map_unit_scale"/>
          <prop v="MM" k="size_unit"/>
          <prop v="1" k="vertical_anchor_point"/>
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
    <field name="rioolput">
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
    <field name="typeknooppunt">
      <editWidget type="">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="breedte_put">
      <editWidget type="">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="lengte_put">
      <editWidget type="">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="grootste_put_afmeting">
      <editWidget type="">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="breedte_leiding">
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
    <alias field="rioolput" name="" index="1"/>
    <alias field="threedi_id" name="" index="2"/>
    <alias field="typeknooppunt" name="" index="3"/>
    <alias field="breedte_put" name="" index="4"/>
    <alias field="lengte_put" name="" index="5"/>
    <alias field="grootste_put_afmeting" name="" index="6"/>
    <alias field="breedte_leiding" name="" index="7"/>
    <alias field="status" name="" index="8"/>
  </aliases>
  <excludeAttributesWMS/>
  <excludeAttributesWFS/>
  <defaults>
    <default field="id" applyOnUpdate="0" expression=""/>
    <default field="rioolput" applyOnUpdate="0" expression=""/>
    <default field="threedi_id" applyOnUpdate="0" expression=""/>
    <default field="typeknooppunt" applyOnUpdate="0" expression=""/>
    <default field="breedte_put" applyOnUpdate="0" expression=""/>
    <default field="lengte_put" applyOnUpdate="0" expression=""/>
    <default field="grootste_put_afmeting" applyOnUpdate="0" expression=""/>
    <default field="breedte_leiding" applyOnUpdate="0" expression=""/>
    <default field="status" applyOnUpdate="0" expression=""/>
  </defaults>
  <constraints>
    <constraint unique_strength="1" exp_strength="0" constraints="3" field="id" notnull_strength="1"/>
    <constraint unique_strength="0" exp_strength="0" constraints="0" field="rioolput" notnull_strength="0"/>
    <constraint unique_strength="0" exp_strength="0" constraints="0" field="threedi_id" notnull_strength="0"/>
    <constraint unique_strength="0" exp_strength="0" constraints="0" field="typeknooppunt" notnull_strength="0"/>
    <constraint unique_strength="0" exp_strength="0" constraints="0" field="breedte_put" notnull_strength="0"/>
    <constraint unique_strength="0" exp_strength="0" constraints="0" field="lengte_put" notnull_strength="0"/>
    <constraint unique_strength="0" exp_strength="0" constraints="0" field="grootste_put_afmeting" notnull_strength="0"/>
    <constraint unique_strength="0" exp_strength="0" constraints="0" field="breedte_leiding" notnull_strength="0"/>
    <constraint unique_strength="0" exp_strength="0" constraints="0" field="status" notnull_strength="0"/>
  </constraints>
  <constraintExpressions>
    <constraint desc="" exp="" field="id"/>
    <constraint desc="" exp="" field="rioolput"/>
    <constraint desc="" exp="" field="threedi_id"/>
    <constraint desc="" exp="" field="typeknooppunt"/>
    <constraint desc="" exp="" field="breedte_put"/>
    <constraint desc="" exp="" field="lengte_put"/>
    <constraint desc="" exp="" field="grootste_put_afmeting"/>
    <constraint desc="" exp="" field="breedte_leiding"/>
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
  <layerGeometryType>0</layerGeometryType>
</qgis>
