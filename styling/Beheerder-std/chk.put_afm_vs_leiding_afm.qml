<!DOCTYPE qgis PUBLIC 'http://mrcc.com/qgis.dtd' 'SYSTEM'>
<qgis styleCategories="Symbology|Labeling" version="3.4.15-Madeira" labelsEnabled="0">
  <renderer-v2 forceraster="0" symbollevels="0" type="RuleRenderer" enableorderby="0">
    <rules key="{5fb80366-4c16-4a1f-9f5d-fa85c5647e61}">
      <rule symbol="0" label="leidingafmeting is groter dan putafmeting" key="{4534d29c-9011-459b-b072-bc84074229da}" filter=" &quot;grootste_put_afmeting&quot; &lt; &quot;breedte_leiding&quot;  AND  &quot;grootste_put_afmeting&quot; > 0"/>
      <rule symbol="1" label="leidingbreedte + buffer is groter is dan de putafmeting" key="{0a36857d-96d6-4bf2-a510-7d2e86891069}" filter="grootste_put_afmeting >= breedte_leiding"/>
    </rules>
    <symbols>
      <symbol name="0" type="marker" clip_to_extent="1" alpha="1" force_rhr="0">
        <layer locked="0" enabled="1" pass="0" class="SimpleMarker">
          <prop k="angle" v="0"/>
          <prop k="color" v="48,193,0,255"/>
          <prop k="horizontal_anchor_point" v="1"/>
          <prop k="joinstyle" v="bevel"/>
          <prop k="name" v="circle"/>
          <prop k="offset" v="0,0"/>
          <prop k="offset_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="offset_unit" v="MM"/>
          <prop k="outline_color" v="35,35,35,255"/>
          <prop k="outline_style" v="solid"/>
          <prop k="outline_width" v="0"/>
          <prop k="outline_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="outline_width_unit" v="MM"/>
          <prop k="scale_method" v="diameter"/>
          <prop k="size" v="2"/>
          <prop k="size_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="size_unit" v="MM"/>
          <prop k="vertical_anchor_point" v="1"/>
          <data_defined_properties>
            <Option type="Map">
              <Option name="name" value="" type="QString"/>
              <Option name="properties"/>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol name="1" type="marker" clip_to_extent="1" alpha="1" force_rhr="0">
        <layer locked="0" enabled="1" pass="0" class="SimpleMarker">
          <prop k="angle" v="0"/>
          <prop k="color" v="203,230,183,255"/>
          <prop k="horizontal_anchor_point" v="1"/>
          <prop k="joinstyle" v="bevel"/>
          <prop k="name" v="circle"/>
          <prop k="offset" v="0,0"/>
          <prop k="offset_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="offset_unit" v="MM"/>
          <prop k="outline_color" v="35,35,35,255"/>
          <prop k="outline_style" v="solid"/>
          <prop k="outline_width" v="0"/>
          <prop k="outline_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="outline_width_unit" v="MM"/>
          <prop k="scale_method" v="diameter"/>
          <prop k="size" v="2"/>
          <prop k="size_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="size_unit" v="MM"/>
          <prop k="vertical_anchor_point" v="1"/>
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
  </renderer-v2>
  <blendMode>0</blendMode>
  <featureBlendMode>0</featureBlendMode>
  <layerGeometryType>0</layerGeometryType>
</qgis>
