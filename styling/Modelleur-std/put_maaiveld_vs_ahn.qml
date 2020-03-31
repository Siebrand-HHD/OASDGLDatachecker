<!DOCTYPE qgis PUBLIC 'http://mrcc.com/qgis.dtd' 'SYSTEM'>
<qgis version="3.4.5-Madeira" labelsEnabled="0" styleCategories="Symbology|Labeling">
  <renderer-v2 symbollevels="0" enableorderby="0" type="RuleRenderer" forceraster="0">
    <rules key="{9ebbe7de-c977-475e-b9d7-bbaf731973a3}">
      <rule key="{497d1ece-b4a2-45db-9b72-141b9848cd45}" filter="&quot;hoogte_verschil&quot; >= -10000.000000 AND &quot;hoogte_verschil&quot; &lt;= -0.500000 AND &quot;manh_manhole_indicator&quot; &lt;> 1" label="&lt; 1" symbol="0"/>
      <rule key="{38074c0f-24a1-421e-ad96-ec23bfd9dee9}" filter="&quot;hoogte_verschil&quot; > -0.500000 AND &quot;hoogte_verschil&quot; &lt;= -0.200000 AND &quot;manh_manhole_indicator&quot; &lt;> 1" label=" -0.50 - -0.20 " symbol="1"/>
      <rule key="{0c455b3e-3a33-454e-a8cf-7eb1c384d809}" filter="&quot;hoogte_verschil&quot; > -0.200000 AND &quot;hoogte_verschil&quot; &lt;= -0.200000 AND &quot;manh_manhole_indicator&quot; &lt;> 1" label=" -0.20 - -0.20 " symbol="2"/>
      <rule checkstate="0" key="{79b9450e-e6ed-425d-ad7f-f1b8a3f9024b}" filter="&quot;hoogte_verschil&quot; > -0.200000 AND &quot;hoogte_verschil&quot; &lt;= 0.200000 AND &quot;manh_manhole_indicator&quot; &lt;> 1" label=" -0.20 - 0.20 " symbol="3"/>
      <rule key="{649a60cb-fb50-481d-bddf-176683b4ca0b}" filter="&quot;hoogte_verschil&quot; > 0.200000 AND &quot;hoogte_verschil&quot; &lt;= 0.500000 AND &quot;manh_manhole_indicator&quot; &lt;> 1" label=" 0.20 - 0.50 " symbol="4"/>
      <rule key="{86ab7110-17eb-41c2-a047-e71adfdf83e9}" filter="&quot;hoogte_verschil&quot; > 0.500000 AND &quot;hoogte_verschil&quot; &lt;= 1.000000 AND &quot;manh_manhole_indicator&quot; &lt;> 1" label=" 0.50 - 1.00 " symbol="5"/>
      <rule key="{3f848ad2-7b7e-428e-b036-386cb2ada477}" filter="&quot;hoogte_verschil&quot; > 1.000000 AND &quot;hoogte_verschil&quot; &lt;= 10000.000000 AND &quot;manh_manhole_indicator&quot; &lt;> 1" label=">  1" symbol="6"/>
      <rule key="{3294f444-0439-4d90-a127-cd642365b716}" filter=" &quot;manh_manhole_indicator&quot; = 1" label="Uitlaten > 0.2" symbol="7"/>
    </rules>
    <symbols>
      <symbol alpha="1" name="0" clip_to_extent="1" type="marker" force_rhr="0">
        <layer enabled="1" locked="0" class="SimpleMarker" pass="4">
          <prop k="angle" v="0"/>
          <prop k="color" v="179,0,0,255"/>
          <prop k="horizontal_anchor_point" v="1"/>
          <prop k="joinstyle" v="bevel"/>
          <prop k="name" v="square"/>
          <prop k="offset" v="0,0"/>
          <prop k="offset_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="offset_unit" v="MM"/>
          <prop k="outline_color" v="0,0,0,255"/>
          <prop k="outline_style" v="solid"/>
          <prop k="outline_width" v="0"/>
          <prop k="outline_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="outline_width_unit" v="MM"/>
          <prop k="scale_method" v="area"/>
          <prop k="size" v="2"/>
          <prop k="size_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="size_unit" v="MM"/>
          <prop k="vertical_anchor_point" v="1"/>
          <data_defined_properties>
            <Option type="Map">
              <Option name="name" type="QString" value=""/>
              <Option name="properties"/>
              <Option name="type" type="QString" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol alpha="1" name="1" clip_to_extent="1" type="marker" force_rhr="0">
        <layer enabled="1" locked="0" class="SimpleMarker" pass="3">
          <prop k="angle" v="0"/>
          <prop k="color" v="235,96,63,255"/>
          <prop k="horizontal_anchor_point" v="1"/>
          <prop k="joinstyle" v="bevel"/>
          <prop k="name" v="square"/>
          <prop k="offset" v="0,0"/>
          <prop k="offset_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="offset_unit" v="MM"/>
          <prop k="outline_color" v="0,0,0,255"/>
          <prop k="outline_style" v="solid"/>
          <prop k="outline_width" v="0"/>
          <prop k="outline_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="outline_width_unit" v="MM"/>
          <prop k="scale_method" v="area"/>
          <prop k="size" v="2"/>
          <prop k="size_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="size_unit" v="MM"/>
          <prop k="vertical_anchor_point" v="1"/>
          <data_defined_properties>
            <Option type="Map">
              <Option name="name" type="QString" value=""/>
              <Option name="properties"/>
              <Option name="type" type="QString" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol alpha="1" name="2" clip_to_extent="1" type="marker" force_rhr="0">
        <layer enabled="1" locked="0" class="SimpleMarker" pass="2">
          <prop k="angle" v="0"/>
          <prop k="color" v="252,183,121,255"/>
          <prop k="horizontal_anchor_point" v="1"/>
          <prop k="joinstyle" v="bevel"/>
          <prop k="name" v="square"/>
          <prop k="offset" v="0,0"/>
          <prop k="offset_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="offset_unit" v="MM"/>
          <prop k="outline_color" v="0,0,0,255"/>
          <prop k="outline_style" v="solid"/>
          <prop k="outline_width" v="0"/>
          <prop k="outline_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="outline_width_unit" v="MM"/>
          <prop k="scale_method" v="area"/>
          <prop k="size" v="2"/>
          <prop k="size_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="size_unit" v="MM"/>
          <prop k="vertical_anchor_point" v="1"/>
          <data_defined_properties>
            <Option type="Map">
              <Option name="name" type="QString" value=""/>
              <Option name="properties"/>
              <Option name="type" type="QString" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol alpha="1" name="3" clip_to_extent="1" type="marker" force_rhr="0">
        <layer enabled="1" locked="0" class="SimpleMarker" pass="1">
          <prop k="angle" v="0"/>
          <prop k="color" v="254,240,217,255"/>
          <prop k="horizontal_anchor_point" v="1"/>
          <prop k="joinstyle" v="bevel"/>
          <prop k="name" v="square"/>
          <prop k="offset" v="0,0"/>
          <prop k="offset_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="offset_unit" v="MM"/>
          <prop k="outline_color" v="0,0,0,255"/>
          <prop k="outline_style" v="solid"/>
          <prop k="outline_width" v="0"/>
          <prop k="outline_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="outline_width_unit" v="MM"/>
          <prop k="scale_method" v="area"/>
          <prop k="size" v="2"/>
          <prop k="size_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="size_unit" v="MM"/>
          <prop k="vertical_anchor_point" v="1"/>
          <data_defined_properties>
            <Option type="Map">
              <Option name="name" type="QString" value=""/>
              <Option name="properties"/>
              <Option name="type" type="QString" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol alpha="1" name="4" clip_to_extent="1" type="marker" force_rhr="0">
        <layer enabled="1" locked="0" class="SimpleMarker" pass="2">
          <prop k="angle" v="0"/>
          <prop k="color" v="253,205,141,255"/>
          <prop k="horizontal_anchor_point" v="1"/>
          <prop k="joinstyle" v="bevel"/>
          <prop k="name" v="square"/>
          <prop k="offset" v="0,0"/>
          <prop k="offset_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="offset_unit" v="MM"/>
          <prop k="outline_color" v="0,0,0,255"/>
          <prop k="outline_style" v="solid"/>
          <prop k="outline_width" v="0"/>
          <prop k="outline_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="outline_width_unit" v="MM"/>
          <prop k="scale_method" v="area"/>
          <prop k="size" v="2"/>
          <prop k="size_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="size_unit" v="MM"/>
          <prop k="vertical_anchor_point" v="1"/>
          <data_defined_properties>
            <Option type="Map">
              <Option name="name" type="QString" value=""/>
              <Option name="properties"/>
              <Option name="type" type="QString" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol alpha="1" name="5" clip_to_extent="1" type="marker" force_rhr="0">
        <layer enabled="1" locked="0" class="SimpleMarker" pass="3">
          <prop k="angle" v="0"/>
          <prop k="color" v="235,96,63,255"/>
          <prop k="horizontal_anchor_point" v="1"/>
          <prop k="joinstyle" v="bevel"/>
          <prop k="name" v="square"/>
          <prop k="offset" v="0,0"/>
          <prop k="offset_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="offset_unit" v="MM"/>
          <prop k="outline_color" v="0,0,0,255"/>
          <prop k="outline_style" v="solid"/>
          <prop k="outline_width" v="0"/>
          <prop k="outline_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="outline_width_unit" v="MM"/>
          <prop k="scale_method" v="area"/>
          <prop k="size" v="2"/>
          <prop k="size_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="size_unit" v="MM"/>
          <prop k="vertical_anchor_point" v="1"/>
          <data_defined_properties>
            <Option type="Map">
              <Option name="name" type="QString" value=""/>
              <Option name="properties"/>
              <Option name="type" type="QString" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol alpha="1" name="6" clip_to_extent="1" type="marker" force_rhr="0">
        <layer enabled="1" locked="0" class="SimpleMarker" pass="4">
          <prop k="angle" v="0"/>
          <prop k="color" v="179,0,0,255"/>
          <prop k="horizontal_anchor_point" v="1"/>
          <prop k="joinstyle" v="bevel"/>
          <prop k="name" v="square"/>
          <prop k="offset" v="0,0"/>
          <prop k="offset_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="offset_unit" v="MM"/>
          <prop k="outline_color" v="0,0,0,255"/>
          <prop k="outline_style" v="solid"/>
          <prop k="outline_width" v="0"/>
          <prop k="outline_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="outline_width_unit" v="MM"/>
          <prop k="scale_method" v="area"/>
          <prop k="size" v="2"/>
          <prop k="size_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="size_unit" v="MM"/>
          <prop k="vertical_anchor_point" v="1"/>
          <data_defined_properties>
            <Option type="Map">
              <Option name="name" type="QString" value=""/>
              <Option name="properties"/>
              <Option name="type" type="QString" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol alpha="1" name="7" clip_to_extent="1" type="marker" force_rhr="0">
        <layer enabled="1" locked="0" class="SimpleMarker" pass="0">
          <prop k="angle" v="0"/>
          <prop k="color" v="185,31,231,255"/>
          <prop k="horizontal_anchor_point" v="1"/>
          <prop k="joinstyle" v="bevel"/>
          <prop k="name" v="square"/>
          <prop k="offset" v="0,0"/>
          <prop k="offset_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="offset_unit" v="MM"/>
          <prop k="outline_color" v="0,0,0,255"/>
          <prop k="outline_style" v="solid"/>
          <prop k="outline_width" v="0"/>
          <prop k="outline_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="outline_width_unit" v="MM"/>
          <prop k="scale_method" v="area"/>
          <prop k="size" v="2"/>
          <prop k="size_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="size_unit" v="MM"/>
          <prop k="vertical_anchor_point" v="1"/>
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
  </renderer-v2>
  <blendMode>0</blendMode>
  <featureBlendMode>0</featureBlendMode>
  <layerGeometryType>0</layerGeometryType>
</qgis>
