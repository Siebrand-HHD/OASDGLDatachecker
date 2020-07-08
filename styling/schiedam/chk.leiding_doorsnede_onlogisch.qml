<!DOCTYPE qgis PUBLIC 'http://mrcc.com/qgis.dtd' 'SYSTEM'>
<qgis labelsEnabled="0" simplifyMaxScale="1" simplifyDrawingHints="1" maxScale="0" hasScaleBasedVisibilityFlag="0" styleCategories="AllStyleCategories" readOnly="0" simplifyLocal="1" minScale="1e+08" version="3.4.15-Madeira" simplifyDrawingTol="1" simplifyAlgorithm="0">
  <flags>
    <Identifiable>1</Identifiable>
    <Removable>1</Removable>
    <Searchable>1</Searchable>
  </flags>
  <renderer-v2 symbollevels="0" forceraster="0" type="singleSymbol" enableorderby="0">
    <symbols>
      <symbol force_rhr="0" clip_to_extent="1" name="0" alpha="1" type="line">
        <layer pass="0" class="SimpleLine" enabled="1" locked="0">
          <prop v="square" k="capstyle"/>
          <prop v="5;2" k="customdash"/>
          <prop v="3x:0,0,0,0,0,0" k="customdash_map_unit_scale"/>
          <prop v="MM" k="customdash_unit"/>
          <prop v="0" k="draw_inside_polygon"/>
          <prop v="bevel" k="joinstyle"/>
          <prop v="114,155,111,255" k="line_color"/>
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
    <field name="vormprofiel">
      <editWidget type="">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="breedte">
      <editWidget type="">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="hoogte">
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
    <alias name="" index="1" field="leiding"/>
    <alias name="" index="2" field="threedi_id"/>
    <alias name="" index="3" field="beginpunt"/>
    <alias name="" index="4" field="eindpunt"/>
    <alias name="" index="5" field="vormprofiel"/>
    <alias name="" index="6" field="breedte"/>
    <alias name="" index="7" field="hoogte"/>
    <alias name="" index="8" field="bericht"/>
    <alias name="" index="9" field="status"/>
  </aliases>
  <excludeAttributesWMS/>
  <excludeAttributesWFS/>
  <defaults>
    <default expression="" applyOnUpdate="0" field="id"/>
    <default expression="" applyOnUpdate="0" field="leiding"/>
    <default expression="" applyOnUpdate="0" field="threedi_id"/>
    <default expression="" applyOnUpdate="0" field="beginpunt"/>
    <default expression="" applyOnUpdate="0" field="eindpunt"/>
    <default expression="" applyOnUpdate="0" field="vormprofiel"/>
    <default expression="" applyOnUpdate="0" field="breedte"/>
    <default expression="" applyOnUpdate="0" field="hoogte"/>
    <default expression="" applyOnUpdate="0" field="bericht"/>
    <default expression="" applyOnUpdate="0" field="status"/>
  </defaults>
  <constraints>
    <constraint constraints="3" notnull_strength="1" exp_strength="0" unique_strength="1" field="id"/>
    <constraint constraints="0" notnull_strength="0" exp_strength="0" unique_strength="0" field="leiding"/>
    <constraint constraints="0" notnull_strength="0" exp_strength="0" unique_strength="0" field="threedi_id"/>
    <constraint constraints="0" notnull_strength="0" exp_strength="0" unique_strength="0" field="beginpunt"/>
    <constraint constraints="0" notnull_strength="0" exp_strength="0" unique_strength="0" field="eindpunt"/>
    <constraint constraints="0" notnull_strength="0" exp_strength="0" unique_strength="0" field="vormprofiel"/>
    <constraint constraints="0" notnull_strength="0" exp_strength="0" unique_strength="0" field="breedte"/>
    <constraint constraints="0" notnull_strength="0" exp_strength="0" unique_strength="0" field="hoogte"/>
    <constraint constraints="0" notnull_strength="0" exp_strength="0" unique_strength="0" field="bericht"/>
    <constraint constraints="0" notnull_strength="0" exp_strength="0" unique_strength="0" field="status"/>
  </constraints>
  <constraintExpressions>
    <constraint desc="" exp="" field="id"/>
    <constraint desc="" exp="" field="leiding"/>
    <constraint desc="" exp="" field="threedi_id"/>
    <constraint desc="" exp="" field="beginpunt"/>
    <constraint desc="" exp="" field="eindpunt"/>
    <constraint desc="" exp="" field="vormprofiel"/>
    <constraint desc="" exp="" field="breedte"/>
    <constraint desc="" exp="" field="hoogte"/>
    <constraint desc="" exp="" field="bericht"/>
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
  <layerGeometryType>1</layerGeometryType>
</qgis>
