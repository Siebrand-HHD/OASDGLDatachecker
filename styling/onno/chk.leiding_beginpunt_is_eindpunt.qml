<!DOCTYPE qgis PUBLIC 'http://mrcc.com/qgis.dtd' 'SYSTEM'>
<qgis hasScaleBasedVisibilityFlag="0" simplifyLocal="1" readOnly="0" simplifyDrawingHints="1" minScale="0" simplifyAlgorithm="0" version="3.8.0-Zanzibar" maxScale="0" labelsEnabled="0" styleCategories="AllStyleCategories" simplifyMaxScale="1" simplifyDrawingTol="1">
  <flags>
    <Identifiable>1</Identifiable>
    <Removable>1</Removable>
    <Searchable>1</Searchable>
  </flags>
  <renderer-v2 symbollevels="0" type="singleSymbol" enableorderby="0" forceraster="0">
    <symbols>
      <symbol clip_to_extent="1" type="marker" name="0" force_rhr="0" alpha="1">
        <layer enabled="1" class="SimpleMarker" locked="0" pass="0">
          <prop v="0" k="angle"/>
          <prop v="0,0,0,255" k="color"/>
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
              <Option type="QString" name="name" value=""/>
              <Option name="properties"/>
              <Option type="QString" name="type" value="collection"/>
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
    <field name="beginpunt_threedi_id">
      <editWidget type="">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="eindpunt_threedi_id">
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
    <alias field="eindpunt" name="" index="4"/>
    <alias field="beginpunt_threedi_id" name="" index="5"/>
    <alias field="eindpunt_threedi_id" name="" index="6"/>
    <alias field="status" name="" index="7"/>
  </aliases>
  <excludeAttributesWMS/>
  <excludeAttributesWFS/>
  <defaults>
    <default field="id" applyOnUpdate="0" expression=""/>
    <default field="leiding" applyOnUpdate="0" expression=""/>
    <default field="threedi_id" applyOnUpdate="0" expression=""/>
    <default field="beginpunt" applyOnUpdate="0" expression=""/>
    <default field="eindpunt" applyOnUpdate="0" expression=""/>
    <default field="beginpunt_threedi_id" applyOnUpdate="0" expression=""/>
    <default field="eindpunt_threedi_id" applyOnUpdate="0" expression=""/>
    <default field="status" applyOnUpdate="0" expression=""/>
  </defaults>
  <constraints>
    <constraint field="id" notnull_strength="1" constraints="3" exp_strength="0" unique_strength="1"/>
    <constraint field="leiding" notnull_strength="0" constraints="0" exp_strength="0" unique_strength="0"/>
    <constraint field="threedi_id" notnull_strength="0" constraints="0" exp_strength="0" unique_strength="0"/>
    <constraint field="beginpunt" notnull_strength="0" constraints="0" exp_strength="0" unique_strength="0"/>
    <constraint field="eindpunt" notnull_strength="0" constraints="0" exp_strength="0" unique_strength="0"/>
    <constraint field="beginpunt_threedi_id" notnull_strength="0" constraints="0" exp_strength="0" unique_strength="0"/>
    <constraint field="eindpunt_threedi_id" notnull_strength="0" constraints="0" exp_strength="0" unique_strength="0"/>
    <constraint field="status" notnull_strength="0" constraints="0" exp_strength="0" unique_strength="0"/>
  </constraints>
  <constraintExpressions>
    <constraint field="id" exp="" desc=""/>
    <constraint field="leiding" exp="" desc=""/>
    <constraint field="threedi_id" exp="" desc=""/>
    <constraint field="beginpunt" exp="" desc=""/>
    <constraint field="eindpunt" exp="" desc=""/>
    <constraint field="beginpunt_threedi_id" exp="" desc=""/>
    <constraint field="eindpunt_threedi_id" exp="" desc=""/>
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
  <layerGeometryType>0</layerGeometryType>
</qgis>
