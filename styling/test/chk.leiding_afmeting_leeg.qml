<!DOCTYPE qgis PUBLIC 'http://mrcc.com/qgis.dtd' 'SYSTEM'>
<qgis styleCategories="AllStyleCategories" hasScaleBasedVisibilityFlag="0" minScale="1e+08" readOnly="0" version="3.8.0-Zanzibar" simplifyDrawingTol="1" labelsEnabled="0" simplifyLocal="1" simplifyMaxScale="1" simplifyDrawingHints="1" maxScale="0" simplifyAlgorithm="0">
  <flags>
    <Identifiable>1</Identifiable>
    <Removable>1</Removable>
    <Searchable>1</Searchable>
  </flags>
  <renderer-v2 forceraster="0" enableorderby="0" type="singleSymbol" symbollevels="0">
    <symbols>
      <symbol clip_to_extent="1" alpha="1" name="0" type="line" force_rhr="0">
        <layer locked="0" class="SimpleLine" enabled="1" pass="0">
          <prop v="square" k="capstyle"/>
          <prop v="5;2" k="customdash"/>
          <prop v="3x:0,0,0,0,0,0" k="customdash_map_unit_scale"/>
          <prop v="MM" k="customdash_unit"/>
          <prop v="0" k="draw_inside_polygon"/>
          <prop v="bevel" k="joinstyle"/>
          <prop v="196,60,57,255" k="line_color"/>
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
      <editWidget type="">
        <config>
          <Option/>
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
    <alias field="vormprofiel" name="" index="5"/>
    <alias field="breedte" name="" index="6"/>
    <alias field="hoogte" name="" index="7"/>
    <alias field="bericht" name="" index="8"/>
    <alias field="status" name="" index="9"/>
  </aliases>
  <excludeAttributesWMS/>
  <excludeAttributesWFS/>
  <defaults>
    <default field="id" applyOnUpdate="0" expression=""/>
    <default field="leiding" applyOnUpdate="0" expression=""/>
    <default field="threedi_id" applyOnUpdate="0" expression=""/>
    <default field="beginpunt" applyOnUpdate="0" expression=""/>
    <default field="eindpunt" applyOnUpdate="0" expression=""/>
    <default field="vormprofiel" applyOnUpdate="0" expression=""/>
    <default field="breedte" applyOnUpdate="0" expression=""/>
    <default field="hoogte" applyOnUpdate="0" expression=""/>
    <default field="bericht" applyOnUpdate="0" expression=""/>
    <default field="status" applyOnUpdate="0" expression=""/>
  </defaults>
  <constraints>
    <constraint exp_strength="0" unique_strength="1" field="id" notnull_strength="1" constraints="3"/>
    <constraint exp_strength="0" unique_strength="0" field="leiding" notnull_strength="0" constraints="0"/>
    <constraint exp_strength="0" unique_strength="0" field="threedi_id" notnull_strength="0" constraints="0"/>
    <constraint exp_strength="0" unique_strength="0" field="beginpunt" notnull_strength="0" constraints="0"/>
    <constraint exp_strength="0" unique_strength="0" field="eindpunt" notnull_strength="0" constraints="0"/>
    <constraint exp_strength="0" unique_strength="0" field="vormprofiel" notnull_strength="0" constraints="0"/>
    <constraint exp_strength="0" unique_strength="0" field="breedte" notnull_strength="0" constraints="0"/>
    <constraint exp_strength="0" unique_strength="0" field="hoogte" notnull_strength="0" constraints="0"/>
    <constraint exp_strength="0" unique_strength="0" field="bericht" notnull_strength="0" constraints="0"/>
    <constraint exp_strength="0" unique_strength="0" field="status" notnull_strength="0" constraints="0"/>
  </constraints>
  <constraintExpressions>
    <constraint exp="" field="id" desc=""/>
    <constraint exp="" field="leiding" desc=""/>
    <constraint exp="" field="threedi_id" desc=""/>
    <constraint exp="" field="beginpunt" desc=""/>
    <constraint exp="" field="eindpunt" desc=""/>
    <constraint exp="" field="vormprofiel" desc=""/>
    <constraint exp="" field="breedte" desc=""/>
    <constraint exp="" field="hoogte" desc=""/>
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
