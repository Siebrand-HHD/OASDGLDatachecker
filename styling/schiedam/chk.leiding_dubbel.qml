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
          <prop v="141,90,153,255" k="line_color"/>
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
    <field name="threedi_ids">
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
    <field name="leidingen">
      <editWidget type="">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="type_leidingen">
      <editWidget type="">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="aantal_leidingen">
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
    <alias name="" index="1" field="threedi_ids"/>
    <alias name="" index="2" field="beginpunt"/>
    <alias name="" index="3" field="eindpunt"/>
    <alias name="" index="4" field="leidingen"/>
    <alias name="" index="5" field="type_leidingen"/>
    <alias name="" index="6" field="aantal_leidingen"/>
    <alias name="" index="7" field="status"/>
  </aliases>
  <excludeAttributesWMS/>
  <excludeAttributesWFS/>
  <defaults>
    <default expression="" applyOnUpdate="0" field="id"/>
    <default expression="" applyOnUpdate="0" field="threedi_ids"/>
    <default expression="" applyOnUpdate="0" field="beginpunt"/>
    <default expression="" applyOnUpdate="0" field="eindpunt"/>
    <default expression="" applyOnUpdate="0" field="leidingen"/>
    <default expression="" applyOnUpdate="0" field="type_leidingen"/>
    <default expression="" applyOnUpdate="0" field="aantal_leidingen"/>
    <default expression="" applyOnUpdate="0" field="status"/>
  </defaults>
  <constraints>
    <constraint constraints="3" notnull_strength="1" exp_strength="0" unique_strength="1" field="id"/>
    <constraint constraints="0" notnull_strength="0" exp_strength="0" unique_strength="0" field="threedi_ids"/>
    <constraint constraints="0" notnull_strength="0" exp_strength="0" unique_strength="0" field="beginpunt"/>
    <constraint constraints="0" notnull_strength="0" exp_strength="0" unique_strength="0" field="eindpunt"/>
    <constraint constraints="0" notnull_strength="0" exp_strength="0" unique_strength="0" field="leidingen"/>
    <constraint constraints="0" notnull_strength="0" exp_strength="0" unique_strength="0" field="type_leidingen"/>
    <constraint constraints="0" notnull_strength="0" exp_strength="0" unique_strength="0" field="aantal_leidingen"/>
    <constraint constraints="0" notnull_strength="0" exp_strength="0" unique_strength="0" field="status"/>
  </constraints>
  <constraintExpressions>
    <constraint desc="" exp="" field="id"/>
    <constraint desc="" exp="" field="threedi_ids"/>
    <constraint desc="" exp="" field="beginpunt"/>
    <constraint desc="" exp="" field="eindpunt"/>
    <constraint desc="" exp="" field="leidingen"/>
    <constraint desc="" exp="" field="type_leidingen"/>
    <constraint desc="" exp="" field="aantal_leidingen"/>
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
