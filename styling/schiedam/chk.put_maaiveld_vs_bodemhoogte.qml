<!DOCTYPE qgis PUBLIC 'http://mrcc.com/qgis.dtd' 'SYSTEM'>
<qgis labelsEnabled="0" simplifyMaxScale="1" simplifyDrawingHints="1" maxScale="0" hasScaleBasedVisibilityFlag="0" styleCategories="AllStyleCategories" readOnly="0" simplifyLocal="1" minScale="1e+08" version="3.4.15-Madeira" simplifyDrawingTol="1" simplifyAlgorithm="0">
  <flags>
    <Identifiable>1</Identifiable>
    <Removable>1</Removable>
    <Searchable>1</Searchable>
  </flags>
  <renderer-v2 symbollevels="0" forceraster="0" type="singleSymbol" enableorderby="0">
    <symbols>
      <symbol force_rhr="0" clip_to_extent="1" name="0" alpha="1" type="marker">
        <layer pass="0" class="SimpleMarker" enabled="1" locked="0">
          <prop v="0" k="angle"/>
          <prop v="229,182,54,255" k="color"/>
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
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
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
  <geometryOptions removeDuplicateNodes="0" geometryPrecision="0">
    <activeChecks type="StringList">
      <Option value="" type="QString"/>
    </activeChecks>
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
    <field name="bodemhoogte">
      <editWidget type="">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="maaiveldhoogte">
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
    <field name="minimale_dekking">
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
              <Option value="gecontroleerd" name="gecontroleerd" type="QString"/>
              <Option value="verwerkt" name="verwerkt" type="QString"/>
            </Option>
          </Option>
        </config>
      </editWidget>
    </field>
  </fieldConfiguration>
  <aliases>
    <alias name="" index="0" field="id"/>
    <alias name="" index="1" field="rioolput"/>
    <alias name="" index="2" field="threedi_id"/>
    <alias name="" index="3" field="typeknooppunt"/>
    <alias name="" index="4" field="bodemhoogte"/>
    <alias name="" index="5" field="maaiveldhoogte"/>
    <alias name="" index="6" field="hoogte_verschil"/>
    <alias name="" index="7" field="minimale_dekking"/>
    <alias name="" index="8" field="status"/>
  </aliases>
  <excludeAttributesWMS/>
  <excludeAttributesWFS/>
  <defaults>
    <default expression="" applyOnUpdate="0" field="id"/>
    <default expression="" applyOnUpdate="0" field="rioolput"/>
    <default expression="" applyOnUpdate="0" field="threedi_id"/>
    <default expression="" applyOnUpdate="0" field="typeknooppunt"/>
    <default expression="" applyOnUpdate="0" field="bodemhoogte"/>
    <default expression="" applyOnUpdate="0" field="maaiveldhoogte"/>
    <default expression="" applyOnUpdate="0" field="hoogte_verschil"/>
    <default expression="" applyOnUpdate="0" field="minimale_dekking"/>
    <default expression="" applyOnUpdate="0" field="status"/>
  </defaults>
  <constraints>
    <constraint constraints="3" notnull_strength="1" exp_strength="0" unique_strength="1" field="id"/>
    <constraint constraints="0" notnull_strength="0" exp_strength="0" unique_strength="0" field="rioolput"/>
    <constraint constraints="0" notnull_strength="0" exp_strength="0" unique_strength="0" field="threedi_id"/>
    <constraint constraints="0" notnull_strength="0" exp_strength="0" unique_strength="0" field="typeknooppunt"/>
    <constraint constraints="0" notnull_strength="0" exp_strength="0" unique_strength="0" field="bodemhoogte"/>
    <constraint constraints="0" notnull_strength="0" exp_strength="0" unique_strength="0" field="maaiveldhoogte"/>
    <constraint constraints="0" notnull_strength="0" exp_strength="0" unique_strength="0" field="hoogte_verschil"/>
    <constraint constraints="0" notnull_strength="0" exp_strength="0" unique_strength="0" field="minimale_dekking"/>
    <constraint constraints="0" notnull_strength="0" exp_strength="0" unique_strength="0" field="status"/>
  </constraints>
  <constraintExpressions>
    <constraint desc="" exp="" field="id"/>
    <constraint desc="" exp="" field="rioolput"/>
    <constraint desc="" exp="" field="threedi_id"/>
    <constraint desc="" exp="" field="typeknooppunt"/>
    <constraint desc="" exp="" field="bodemhoogte"/>
    <constraint desc="" exp="" field="maaiveldhoogte"/>
    <constraint desc="" exp="" field="hoogte_verschil"/>
    <constraint desc="" exp="" field="minimale_dekking"/>
    <constraint desc="" exp="" field="status"/>
  </constraintExpressions>
  <expressionfields/>
  <attributeactions/>
  <attributetableconfig sortOrder="0" actionWidgetStyle="dropDown" sortExpression="">
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
