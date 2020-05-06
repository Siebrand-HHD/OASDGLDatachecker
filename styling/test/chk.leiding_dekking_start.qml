<!DOCTYPE qgis PUBLIC 'http://mrcc.com/qgis.dtd' 'SYSTEM'>
<qgis simplifyAlgorithm="0" readOnly="0" version="3.8.0-Zanzibar" simplifyDrawingTol="1" styleCategories="AllStyleCategories" simplifyMaxScale="1" maxScale="0" labelsEnabled="0" hasScaleBasedVisibilityFlag="0" minScale="1e+08" simplifyDrawingHints="1" simplifyLocal="1">
  <flags>
    <Identifiable>1</Identifiable>
    <Removable>1</Removable>
    <Searchable>1</Searchable>
  </flags>
  <renderer-v2 enableorderby="0" forceraster="0" symbollevels="0" type="singleSymbol">
    <symbols>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" name="0" type="line">
        <layer enabled="1" locked="0" class="SimpleLine" pass="0">
          <prop k="capstyle" v="square"/>
          <prop k="customdash" v="5;2"/>
          <prop k="customdash_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="customdash_unit" v="MM"/>
          <prop k="draw_inside_polygon" v="0"/>
          <prop k="joinstyle" v="bevel"/>
          <prop k="line_color" v="133,182,111,255"/>
          <prop k="line_style" v="solid"/>
          <prop k="line_width" v="0.26"/>
          <prop k="line_width_unit" v="MM"/>
          <prop k="offset" v="0"/>
          <prop k="offset_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="offset_unit" v="MM"/>
          <prop k="ring_filter" v="0"/>
          <prop k="use_custom_dash" v="0"/>
          <prop k="width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
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
  <geometryOptions geometryPrecision="0" removeDuplicateNodes="0">
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
    <field name="bob_beginpunt">
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
      <editWidget type="">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
  </fieldConfiguration>
  <aliases>
    <alias field="id" index="0" name=""/>
    <alias field="leiding" index="1" name=""/>
    <alias field="threedi_id" index="2" name=""/>
    <alias field="beginpunt" index="3" name=""/>
    <alias field="bob_beginpunt" index="4" name=""/>
    <alias field="hoogte_profiel" index="5" name=""/>
    <alias field="bovenkant_leiding" index="6" name=""/>
    <alias field="put_maaiveldhoogte" index="7" name=""/>
    <alias field="ahn_maaiveldhoogte" index="8" name=""/>
    <alias field="dekking_put_maaiveldhoogte" index="9" name=""/>
    <alias field="dekking_ahn_maaiveldhoogte" index="10" name=""/>
    <alias field="status" index="11" name=""/>
  </aliases>
  <excludeAttributesWMS/>
  <excludeAttributesWFS/>
  <defaults>
    <default field="id" applyOnUpdate="0" expression=""/>
    <default field="leiding" applyOnUpdate="0" expression=""/>
    <default field="threedi_id" applyOnUpdate="0" expression=""/>
    <default field="beginpunt" applyOnUpdate="0" expression=""/>
    <default field="bob_beginpunt" applyOnUpdate="0" expression=""/>
    <default field="hoogte_profiel" applyOnUpdate="0" expression=""/>
    <default field="bovenkant_leiding" applyOnUpdate="0" expression=""/>
    <default field="put_maaiveldhoogte" applyOnUpdate="0" expression=""/>
    <default field="ahn_maaiveldhoogte" applyOnUpdate="0" expression=""/>
    <default field="dekking_put_maaiveldhoogte" applyOnUpdate="0" expression=""/>
    <default field="dekking_ahn_maaiveldhoogte" applyOnUpdate="0" expression=""/>
    <default field="status" applyOnUpdate="0" expression=""/>
  </defaults>
  <constraints>
    <constraint exp_strength="0" field="id" unique_strength="1" constraints="3" notnull_strength="1"/>
    <constraint exp_strength="0" field="leiding" unique_strength="0" constraints="0" notnull_strength="0"/>
    <constraint exp_strength="0" field="threedi_id" unique_strength="0" constraints="0" notnull_strength="0"/>
    <constraint exp_strength="0" field="beginpunt" unique_strength="0" constraints="0" notnull_strength="0"/>
    <constraint exp_strength="0" field="bob_beginpunt" unique_strength="0" constraints="0" notnull_strength="0"/>
    <constraint exp_strength="0" field="hoogte_profiel" unique_strength="0" constraints="0" notnull_strength="0"/>
    <constraint exp_strength="0" field="bovenkant_leiding" unique_strength="0" constraints="0" notnull_strength="0"/>
    <constraint exp_strength="0" field="put_maaiveldhoogte" unique_strength="0" constraints="0" notnull_strength="0"/>
    <constraint exp_strength="0" field="ahn_maaiveldhoogte" unique_strength="0" constraints="0" notnull_strength="0"/>
    <constraint exp_strength="0" field="dekking_put_maaiveldhoogte" unique_strength="0" constraints="0" notnull_strength="0"/>
    <constraint exp_strength="0" field="dekking_ahn_maaiveldhoogte" unique_strength="0" constraints="0" notnull_strength="0"/>
    <constraint exp_strength="0" field="status" unique_strength="0" constraints="0" notnull_strength="0"/>
  </constraints>
  <constraintExpressions>
    <constraint exp="" field="id" desc=""/>
    <constraint exp="" field="leiding" desc=""/>
    <constraint exp="" field="threedi_id" desc=""/>
    <constraint exp="" field="beginpunt" desc=""/>
    <constraint exp="" field="bob_beginpunt" desc=""/>
    <constraint exp="" field="hoogte_profiel" desc=""/>
    <constraint exp="" field="bovenkant_leiding" desc=""/>
    <constraint exp="" field="put_maaiveldhoogte" desc=""/>
    <constraint exp="" field="ahn_maaiveldhoogte" desc=""/>
    <constraint exp="" field="dekking_put_maaiveldhoogte" desc=""/>
    <constraint exp="" field="dekking_ahn_maaiveldhoogte" desc=""/>
    <constraint exp="" field="status" desc=""/>
  </constraintExpressions>
  <expressionfields/>
  <attributeactions/>
  <attributetableconfig actionWidgetStyle="dropDown" sortExpression="" sortOrder="0">
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
