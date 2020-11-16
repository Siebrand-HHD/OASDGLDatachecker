<!DOCTYPE qgis PUBLIC 'http://mrcc.com/qgis.dtd' 'SYSTEM'>
<qgis version="3.8.0-Zanzibar" labelsEnabled="0" styleCategories="AllStyleCategories" minScale="0" readOnly="0" hasScaleBasedVisibilityFlag="0" simplifyAlgorithm="0" simplifyDrawingHints="1" simplifyMaxScale="1" maxScale="0" simplifyDrawingTol="1" simplifyLocal="1">
  <flags>
    <Identifiable>1</Identifiable>
    <Removable>1</Removable>
    <Searchable>1</Searchable>
  </flags>
  <renderer-v2 type="RuleRenderer" forceraster="0" enableorderby="0" symbollevels="0">
    <rules key="{391f137c-8900-4e26-ab5b-a7e6326e4524}">
      <rule filter="&quot;hoogte_verschil&quot; &lt; -0.5" key="{11b6c976-759c-430a-aad7-f2ed0a1a149e}" symbol="0" label="maaiveld put meer dan 50cm lager"/>
      <rule filter="&quot;hoogte_verschil&quot; >= -0.5 AND &quot;hoogte_verschil&quot; &lt;= -0.2" key="{9ac56da5-2d1a-4e6c-a4a4-181b0e818dee}" symbol="1" label="-20cm tot -50cm"/>
      <rule filter="&quot;hoogte_verschil&quot; >= 0.2 AND &quot;hoogte_verschil&quot; &lt;= 0.5" key="{b87f00cd-9276-46cf-aa37-725d72abdaf5}" symbol="2" label="20cm tot 50cm"/>
      <rule filter="&quot;hoogte_verschil&quot; > 0.5" key="{6ea2997f-03b3-45ac-8b36-fe9abff6e8a8}" symbol="3" label="maaiveld put meer dan 50cm hoger"/>
    </rules>
    <symbols>
      <symbol type="marker" alpha="1" clip_to_extent="1" force_rhr="0" name="0">
        <layer pass="0" enabled="1" class="SimpleMarker" locked="0">
          <prop v="0" k="angle"/>
          <prop v="202,0,32,255" k="color"/>
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
          <prop v="244,165,130,255" k="color"/>
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
      <symbol type="marker" alpha="1" clip_to_extent="1" force_rhr="0" name="2">
        <layer pass="0" enabled="1" class="SimpleMarker" locked="0">
          <prop v="0" k="angle"/>
          <prop v="186,186,186,255" k="color"/>
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
      <symbol type="marker" alpha="1" clip_to_extent="1" force_rhr="0" name="3">
        <layer pass="0" enabled="1" class="SimpleMarker" locked="0">
          <prop v="0" k="angle"/>
          <prop v="64,64,64,255" k="color"/>
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
    <field name="hoogte_verschil">
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
    <alias field="put_maaiveldhoogte" name="" index="3"/>
    <alias field="ahn_maaiveldhoogte" name="" index="4"/>
    <alias field="hoogte_verschil" name="" index="5"/>
    <alias field="status" name="" index="6"/>
  </aliases>
  <excludeAttributesWMS/>
  <excludeAttributesWFS/>
  <defaults>
    <default field="id" applyOnUpdate="0" expression=""/>
    <default field="rioolput" applyOnUpdate="0" expression=""/>
    <default field="threedi_id" applyOnUpdate="0" expression=""/>
    <default field="put_maaiveldhoogte" applyOnUpdate="0" expression=""/>
    <default field="ahn_maaiveldhoogte" applyOnUpdate="0" expression=""/>
    <default field="hoogte_verschil" applyOnUpdate="0" expression=""/>
    <default field="status" applyOnUpdate="0" expression=""/>
  </defaults>
  <constraints>
    <constraint unique_strength="1" exp_strength="0" constraints="3" field="id" notnull_strength="1"/>
    <constraint unique_strength="0" exp_strength="0" constraints="0" field="rioolput" notnull_strength="0"/>
    <constraint unique_strength="0" exp_strength="0" constraints="0" field="threedi_id" notnull_strength="0"/>
    <constraint unique_strength="0" exp_strength="0" constraints="0" field="put_maaiveldhoogte" notnull_strength="0"/>
    <constraint unique_strength="0" exp_strength="0" constraints="0" field="ahn_maaiveldhoogte" notnull_strength="0"/>
    <constraint unique_strength="0" exp_strength="0" constraints="0" field="hoogte_verschil" notnull_strength="0"/>
    <constraint unique_strength="0" exp_strength="0" constraints="0" field="status" notnull_strength="0"/>
  </constraints>
  <constraintExpressions>
    <constraint desc="" exp="" field="id"/>
    <constraint desc="" exp="" field="rioolput"/>
    <constraint desc="" exp="" field="threedi_id"/>
    <constraint desc="" exp="" field="put_maaiveldhoogte"/>
    <constraint desc="" exp="" field="ahn_maaiveldhoogte"/>
    <constraint desc="" exp="" field="hoogte_verschil"/>
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
