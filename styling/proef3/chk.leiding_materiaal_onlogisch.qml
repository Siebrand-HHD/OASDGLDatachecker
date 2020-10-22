<!DOCTYPE qgis PUBLIC 'http://mrcc.com/qgis.dtd' 'SYSTEM'>
<qgis labelsEnabled="0" simplifyDrawingHints="1" maxScale="0" simplifyAlgorithm="0" styleCategories="AllStyleCategories" hasScaleBasedVisibilityFlag="0" simplifyDrawingTol="1" simplifyMaxScale="1" minScale="0" version="3.8.0-Zanzibar" simplifyLocal="1" readOnly="0">
  <flags>
    <Identifiable>1</Identifiable>
    <Removable>1</Removable>
    <Searchable>1</Searchable>
  </flags>
  <renderer-v2 symbollevels="0" enableorderby="0" forceraster="0" type="singleSymbol">
    <symbols>
      <symbol name="0" force_rhr="0" clip_to_extent="1" alpha="1" type="line">
        <layer pass="0" locked="0" class="SimpleLine" enabled="1">
          <prop k="capstyle" v="square"/>
          <prop k="customdash" v="5;2"/>
          <prop k="customdash_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="customdash_unit" v="MM"/>
          <prop k="draw_inside_polygon" v="0"/>
          <prop k="joinstyle" v="bevel"/>
          <prop k="line_color" v="198,137,56,255"/>
          <prop k="line_style" v="dash dot"/>
          <prop k="line_width" v="0.66"/>
          <prop k="line_width_unit" v="MM"/>
          <prop k="offset" v="0"/>
          <prop k="offset_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="offset_unit" v="MM"/>
          <prop k="ring_filter" v="0"/>
          <prop k="use_custom_dash" v="0"/>
          <prop k="width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
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
    <field name="bericht">
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
    <alias name="" field="leiding" index="1"/>
    <alias name="" field="threedi_id" index="2"/>
    <alias name="" field="beginpunt" index="3"/>
    <alias name="" field="eindpunt" index="4"/>
    <alias name="" field="bericht" index="5"/>
    <alias name="" field="status" index="6"/>
  </aliases>
  <excludeAttributesWMS/>
  <excludeAttributesWFS/>
  <defaults>
    <default field="id" applyOnUpdate="0" expression=""/>
    <default field="leiding" applyOnUpdate="0" expression=""/>
    <default field="threedi_id" applyOnUpdate="0" expression=""/>
    <default field="beginpunt" applyOnUpdate="0" expression=""/>
    <default field="eindpunt" applyOnUpdate="0" expression=""/>
    <default field="bericht" applyOnUpdate="0" expression=""/>
    <default field="status" applyOnUpdate="0" expression=""/>
  </defaults>
  <constraints>
    <constraint field="id" constraints="3" exp_strength="0" unique_strength="1" notnull_strength="1"/>
    <constraint field="leiding" constraints="0" exp_strength="0" unique_strength="0" notnull_strength="0"/>
    <constraint field="threedi_id" constraints="0" exp_strength="0" unique_strength="0" notnull_strength="0"/>
    <constraint field="beginpunt" constraints="0" exp_strength="0" unique_strength="0" notnull_strength="0"/>
    <constraint field="eindpunt" constraints="0" exp_strength="0" unique_strength="0" notnull_strength="0"/>
    <constraint field="bericht" constraints="0" exp_strength="0" unique_strength="0" notnull_strength="0"/>
    <constraint field="status" constraints="0" exp_strength="0" unique_strength="0" notnull_strength="0"/>
  </constraints>
  <constraintExpressions>
    <constraint exp="" field="id" desc=""/>
    <constraint exp="" field="leiding" desc=""/>
    <constraint exp="" field="threedi_id" desc=""/>
    <constraint exp="" field="beginpunt" desc=""/>
    <constraint exp="" field="eindpunt" desc=""/>
    <constraint exp="" field="bericht" desc=""/>
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
  <layerGeometryType>1</layerGeometryType>
</qgis>
