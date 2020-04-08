<!DOCTYPE qgis PUBLIC 'http://mrcc.com/qgis.dtd' 'SYSTEM'>
<qgis minScale="1e+08" readOnly="0" version="3.8.0-Zanzibar" labelsEnabled="0" simplifyAlgorithm="0" styleCategories="AllStyleCategories" maxScale="0" simplifyDrawingTol="1" simplifyDrawingHints="1" simplifyMaxScale="1" hasScaleBasedVisibilityFlag="0" simplifyLocal="1">
  <flags>
    <Identifiable>1</Identifiable>
    <Removable>1</Removable>
    <Searchable>1</Searchable>
  </flags>
  <renderer-v2 symbollevels="0" enableorderby="0" type="singleSymbol" forceraster="0">
    <symbols>
      <symbol clip_to_extent="1" alpha="1" force_rhr="0" name="0" type="line">
        <layer locked="0" class="SimpleLine" pass="0" enabled="1">
          <prop v="square" k="capstyle"/>
          <prop v="5;2" k="customdash"/>
          <prop v="3x:0,0,0,0,0,0" k="customdash_map_unit_scale"/>
          <prop v="MM" k="customdash_unit"/>
          <prop v="0" k="draw_inside_polygon"/>
          <prop v="bevel" k="joinstyle"/>
          <prop v="232,113,141,255" k="line_color"/>
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
  <customproperties/>
  <blendMode>0</blendMode>
  <featureBlendMode>0</featureBlendMode>
  <layerOpacity>1</layerOpacity>
  <geometryOptions geometryPrecision="0" removeDuplicateNodes="0">
    <activeChecks type="StringList">
      <Option type="QString" value=""/>
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
    <default field="id" expression="" applyOnUpdate="0"/>
    <default field="leiding" expression="" applyOnUpdate="0"/>
    <default field="threedi_id" expression="" applyOnUpdate="0"/>
    <default field="beginpunt" expression="" applyOnUpdate="0"/>
    <default field="bob_beginpunt" expression="" applyOnUpdate="0"/>
    <default field="hoogte_profiel" expression="" applyOnUpdate="0"/>
    <default field="bovenkant_leiding" expression="" applyOnUpdate="0"/>
    <default field="put_maaiveldhoogte" expression="" applyOnUpdate="0"/>
    <default field="ahn_maaiveldhoogte" expression="" applyOnUpdate="0"/>
    <default field="dekking_put_maaiveldhoogte" expression="" applyOnUpdate="0"/>
    <default field="dekking_ahn_maaiveldhoogte" expression="" applyOnUpdate="0"/>
    <default field="status" expression="" applyOnUpdate="0"/>
  </defaults>
  <constraints>
    <constraint constraints="3" field="id" notnull_strength="1" exp_strength="0" unique_strength="1"/>
    <constraint constraints="0" field="leiding" notnull_strength="0" exp_strength="0" unique_strength="0"/>
    <constraint constraints="0" field="threedi_id" notnull_strength="0" exp_strength="0" unique_strength="0"/>
    <constraint constraints="0" field="beginpunt" notnull_strength="0" exp_strength="0" unique_strength="0"/>
    <constraint constraints="0" field="bob_beginpunt" notnull_strength="0" exp_strength="0" unique_strength="0"/>
    <constraint constraints="0" field="hoogte_profiel" notnull_strength="0" exp_strength="0" unique_strength="0"/>
    <constraint constraints="0" field="bovenkant_leiding" notnull_strength="0" exp_strength="0" unique_strength="0"/>
    <constraint constraints="0" field="put_maaiveldhoogte" notnull_strength="0" exp_strength="0" unique_strength="0"/>
    <constraint constraints="0" field="ahn_maaiveldhoogte" notnull_strength="0" exp_strength="0" unique_strength="0"/>
    <constraint constraints="0" field="dekking_put_maaiveldhoogte" notnull_strength="0" exp_strength="0" unique_strength="0"/>
    <constraint constraints="0" field="dekking_ahn_maaiveldhoogte" notnull_strength="0" exp_strength="0" unique_strength="0"/>
    <constraint constraints="0" field="status" notnull_strength="0" exp_strength="0" unique_strength="0"/>
  </constraints>
  <constraintExpressions>
    <constraint field="id" desc="" exp=""/>
    <constraint field="leiding" desc="" exp=""/>
    <constraint field="threedi_id" desc="" exp=""/>
    <constraint field="beginpunt" desc="" exp=""/>
    <constraint field="bob_beginpunt" desc="" exp=""/>
    <constraint field="hoogte_profiel" desc="" exp=""/>
    <constraint field="bovenkant_leiding" desc="" exp=""/>
    <constraint field="put_maaiveldhoogte" desc="" exp=""/>
    <constraint field="ahn_maaiveldhoogte" desc="" exp=""/>
    <constraint field="dekking_put_maaiveldhoogte" desc="" exp=""/>
    <constraint field="dekking_ahn_maaiveldhoogte" desc="" exp=""/>
    <constraint field="status" desc="" exp=""/>
  </constraintExpressions>
  <expressionfields/>
  <attributeactions/>
  <attributetableconfig sortExpression="" sortOrder="0" actionWidgetStyle="dropDown">
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
