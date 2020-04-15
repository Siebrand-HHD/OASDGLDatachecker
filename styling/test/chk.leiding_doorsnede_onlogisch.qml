<!DOCTYPE qgis PUBLIC 'http://mrcc.com/qgis.dtd' 'SYSTEM'>
<qgis minScale="1e+08" maxScale="0" simplifyAlgorithm="0" hasScaleBasedVisibilityFlag="0" simplifyDrawingTol="1" readOnly="0" version="3.8.0-Zanzibar" labelsEnabled="0" simplifyLocal="1" simplifyDrawingHints="1" styleCategories="AllStyleCategories" simplifyMaxScale="1">
  <flags>
    <Identifiable>1</Identifiable>
    <Removable>1</Removable>
    <Searchable>1</Searchable>
  </flags>
  <renderer-v2 enableorderby="0" symbollevels="0" type="singleSymbol" forceraster="0">
    <symbols>
      <symbol name="0" alpha="1" force_rhr="0" type="line" clip_to_extent="1">
        <layer enabled="1" class="SimpleLine" pass="0" locked="0">
          <prop v="square" k="capstyle"/>
          <prop v="5;2" k="customdash"/>
          <prop v="3x:0,0,0,0,0,0" k="customdash_map_unit_scale"/>
          <prop v="MM" k="customdash_unit"/>
          <prop v="0" k="draw_inside_polygon"/>
          <prop v="bevel" k="joinstyle"/>
          <prop v="225,89,137,255" k="line_color"/>
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
              <Option name="name" value="" type="QString"/>
              <Option name="properties"/>
              <Option name="type" value="collection" type="QString"/>
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
              <Option name="gecontroleerd" value="gecontroleerd" type="QString"/>
              <Option name="verwerkt" value="verwerkt" type="QString"/>
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
    <default field="id" expression="" applyOnUpdate="0"/>
    <default field="leiding" expression="" applyOnUpdate="0"/>
    <default field="threedi_id" expression="" applyOnUpdate="0"/>
    <default field="beginpunt" expression="" applyOnUpdate="0"/>
    <default field="eindpunt" expression="" applyOnUpdate="0"/>
    <default field="vormprofiel" expression="" applyOnUpdate="0"/>
    <default field="breedte" expression="" applyOnUpdate="0"/>
    <default field="hoogte" expression="" applyOnUpdate="0"/>
    <default field="bericht" expression="" applyOnUpdate="0"/>
    <default field="status" expression="" applyOnUpdate="0"/>
  </defaults>
  <constraints>
    <constraint constraints="3" field="id" notnull_strength="1" unique_strength="1" exp_strength="0"/>
    <constraint constraints="0" field="leiding" notnull_strength="0" unique_strength="0" exp_strength="0"/>
    <constraint constraints="0" field="threedi_id" notnull_strength="0" unique_strength="0" exp_strength="0"/>
    <constraint constraints="0" field="beginpunt" notnull_strength="0" unique_strength="0" exp_strength="0"/>
    <constraint constraints="0" field="eindpunt" notnull_strength="0" unique_strength="0" exp_strength="0"/>
    <constraint constraints="0" field="vormprofiel" notnull_strength="0" unique_strength="0" exp_strength="0"/>
    <constraint constraints="0" field="breedte" notnull_strength="0" unique_strength="0" exp_strength="0"/>
    <constraint constraints="0" field="hoogte" notnull_strength="0" unique_strength="0" exp_strength="0"/>
    <constraint constraints="0" field="bericht" notnull_strength="0" unique_strength="0" exp_strength="0"/>
    <constraint constraints="0" field="status" notnull_strength="0" unique_strength="0" exp_strength="0"/>
  </constraints>
  <constraintExpressions>
    <constraint exp="" desc="" field="id"/>
    <constraint exp="" desc="" field="leiding"/>
    <constraint exp="" desc="" field="threedi_id"/>
    <constraint exp="" desc="" field="beginpunt"/>
    <constraint exp="" desc="" field="eindpunt"/>
    <constraint exp="" desc="" field="vormprofiel"/>
    <constraint exp="" desc="" field="breedte"/>
    <constraint exp="" desc="" field="hoogte"/>
    <constraint exp="" desc="" field="bericht"/>
    <constraint exp="" desc="" field="status"/>
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
  <layerGeometryType>1</layerGeometryType>
</qgis>
