<!DOCTYPE qgis PUBLIC 'http://mrcc.com/qgis.dtd' 'SYSTEM'>
<qgis labelsEnabled="0" simplifyDrawingHints="1" maxScale="0" simplifyAlgorithm="0" styleCategories="AllStyleCategories" hasScaleBasedVisibilityFlag="0" simplifyDrawingTol="1" simplifyMaxScale="1" minScale="0" version="3.8.0-Zanzibar" simplifyLocal="1" readOnly="0">
  <flags>
    <Identifiable>1</Identifiable>
    <Removable>1</Removable>
    <Searchable>1</Searchable>
  </flags>
  <renderer-v2 symbollevels="0" enableorderby="0" forceraster="0" type="RuleRenderer">
    <rules key="{5fb80366-4c16-4a1f-9f5d-fa85c5647e61}">
      <rule label="leidingafmeting is groter dan putafmeting" key="{4534d29c-9011-459b-b072-bc84074229da}" symbol="0" filter=" &quot;grootste_put_afmeting&quot; &lt; &quot;breedte_leiding&quot;  AND  &quot;grootste_put_afmeting&quot; > 0"/>
      <rule label="leidingbreedte + buffer is groter is dan de putafmeting" key="{0a36857d-96d6-4bf2-a510-7d2e86891069}" symbol="1" filter="grootste_put_afmeting >= breedte_leiding"/>
    </rules>
    <symbols>
      <symbol name="0" force_rhr="0" clip_to_extent="1" alpha="1" type="marker">
        <layer pass="0" locked="0" class="SimpleMarker" enabled="1">
          <prop k="angle" v="0"/>
          <prop k="color" v="48,193,0,255"/>
          <prop k="horizontal_anchor_point" v="1"/>
          <prop k="joinstyle" v="bevel"/>
          <prop k="name" v="circle"/>
          <prop k="offset" v="0,0"/>
          <prop k="offset_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="offset_unit" v="MM"/>
          <prop k="outline_color" v="35,35,35,255"/>
          <prop k="outline_style" v="solid"/>
          <prop k="outline_width" v="0"/>
          <prop k="outline_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="outline_width_unit" v="MM"/>
          <prop k="scale_method" v="diameter"/>
          <prop k="size" v="2"/>
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
      <symbol name="1" force_rhr="0" clip_to_extent="1" alpha="1" type="marker">
        <layer pass="0" locked="0" class="SimpleMarker" enabled="1">
          <prop k="angle" v="0"/>
          <prop k="color" v="203,230,183,255"/>
          <prop k="horizontal_anchor_point" v="1"/>
          <prop k="joinstyle" v="bevel"/>
          <prop k="name" v="circle"/>
          <prop k="offset" v="0,0"/>
          <prop k="offset_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="offset_unit" v="MM"/>
          <prop k="outline_color" v="35,35,35,255"/>
          <prop k="outline_style" v="solid"/>
          <prop k="outline_width" v="0"/>
          <prop k="outline_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="outline_width_unit" v="MM"/>
          <prop k="scale_method" v="diameter"/>
          <prop k="size" v="2"/>
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
    <alias name="" field="typeknooppunt" index="3"/>
    <alias name="" field="breedte_put" index="4"/>
    <alias name="" field="lengte_put" index="5"/>
    <alias name="" field="grootste_put_afmeting" index="6"/>
    <alias name="" field="breedte_leiding" index="7"/>
    <alias name="" field="status" index="8"/>
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
    <constraint field="id" constraints="3" exp_strength="0" unique_strength="1" notnull_strength="1"/>
    <constraint field="rioolput" constraints="0" exp_strength="0" unique_strength="0" notnull_strength="0"/>
    <constraint field="threedi_id" constraints="0" exp_strength="0" unique_strength="0" notnull_strength="0"/>
    <constraint field="typeknooppunt" constraints="0" exp_strength="0" unique_strength="0" notnull_strength="0"/>
    <constraint field="breedte_put" constraints="0" exp_strength="0" unique_strength="0" notnull_strength="0"/>
    <constraint field="lengte_put" constraints="0" exp_strength="0" unique_strength="0" notnull_strength="0"/>
    <constraint field="grootste_put_afmeting" constraints="0" exp_strength="0" unique_strength="0" notnull_strength="0"/>
    <constraint field="breedte_leiding" constraints="0" exp_strength="0" unique_strength="0" notnull_strength="0"/>
    <constraint field="status" constraints="0" exp_strength="0" unique_strength="0" notnull_strength="0"/>
  </constraints>
  <constraintExpressions>
    <constraint exp="" field="id" desc=""/>
    <constraint exp="" field="rioolput" desc=""/>
    <constraint exp="" field="threedi_id" desc=""/>
    <constraint exp="" field="typeknooppunt" desc=""/>
    <constraint exp="" field="breedte_put" desc=""/>
    <constraint exp="" field="lengte_put" desc=""/>
    <constraint exp="" field="grootste_put_afmeting" desc=""/>
    <constraint exp="" field="breedte_leiding" desc=""/>
    <constraint exp="" field="status" desc=""/>
  </constraintExpressions>
  <expressionfields/>
  <attributeactions/>
  <attributetableconfig actionWidgetStyle="dropDown" sortOrder="0" sortExpression="">
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
