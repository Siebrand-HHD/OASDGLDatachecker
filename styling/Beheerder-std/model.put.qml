<!DOCTYPE qgis PUBLIC 'http://mrcc.com/qgis.dtd' 'SYSTEM'>
<qgis styleCategories="Symbology|Labeling" labelsEnabled="1" version="3.4.15-Madeira">
  <renderer-v2 type="RuleRenderer" forceraster="0" enableorderby="0" symbollevels="0">
    <rules key="{e4438d9a-7f72-4911-a6be-6292c7ad2e68}">
      <rule symbol="0" scalemindenom="1" filter="&quot;typeknooppunt&quot; = 'inspectieput'" scalemaxdenom="5000" label="inspectieput" key="{74bfc7d4-f299-4d26-9fee-bb4f9b43006b}"/>
      <rule symbol="1" scalemindenom="1" filter="&quot;typeknooppunt&quot; = 'pomp'" scalemaxdenom="5000" label="pomp" key="{c2277bf1-0a02-4dfe-b668-1745bc72b629}"/>
      <rule symbol="2" scalemindenom="1" filter="&quot;typeknooppunt&quot; = 'uitlaat'" scalemaxdenom="5000" label="uitlaat" key="{28be3702-c2ce-46e3-8bf4-798fd27398cc}"/>
    </rules>
    <symbols>
      <symbol type="marker" alpha="1" name="0" force_rhr="0" clip_to_extent="1">
        <layer class="SimpleMarker" locked="0" enabled="1" pass="0">
          <prop v="0" k="angle"/>
          <prop v="255,255,255,255" k="color"/>
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
              <Option type="QString" value="" name="name"/>
              <Option type="Map" name="properties">
                <Option type="Map" name="angle">
                  <Option type="bool" value="false" name="active"/>
                  <Option type="QString" value="angle_at_vertex( geometry(get_feature('leiding', 'beginpuntleiding', rioolput)),0)" name="expression"/>
                  <Option type="int" value="3" name="type"/>
                </Option>
              </Option>
              <Option type="QString" value="collection" name="type"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol type="marker" alpha="1" name="1" force_rhr="0" clip_to_extent="1">
        <layer class="SimpleMarker" locked="0" enabled="1" pass="0">
          <prop v="0" k="angle"/>
          <prop v="255,255,255,255" k="color"/>
          <prop v="1" k="horizontal_anchor_point"/>
          <prop v="bevel" k="joinstyle"/>
          <prop v="pentagon" k="name"/>
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
              <Option type="QString" value="" name="name"/>
              <Option name="properties"/>
              <Option type="QString" value="collection" name="type"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol type="marker" alpha="1" name="2" force_rhr="0" clip_to_extent="1">
        <layer class="SimpleMarker" locked="0" enabled="1" pass="0">
          <prop v="0" k="angle"/>
          <prop v="255,255,255,255" k="color"/>
          <prop v="1" k="horizontal_anchor_point"/>
          <prop v="bevel" k="joinstyle"/>
          <prop v="triangle" k="name"/>
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
              <Option type="QString" value="" name="name"/>
              <Option name="properties"/>
              <Option type="QString" value="collection" name="type"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
    </symbols>
  </renderer-v2>
  <labeling type="rule-based">
    <rules key="{8b81e35e-78b3-4394-b165-7a5a1fe0cfab}">
      <rule scalemindenom="1" scalemaxdenom="1000" key="{7f5a7c45-a70f-400f-b669-f4eec9d97cec}">
        <settings>
          <text-style fontCapitals="0" fontUnderline="0" previewBkgrdColor="#ffffff" fontFamily="MS Shell Dlg 2" namedStyle="Regular" textOpacity="1" multilineHeight="1" fontSizeUnit="Point" useSubstitutions="0" fieldName="rioolput" textColor="0,0,0,255" fontWordSpacing="0" fontLetterSpacing="0" fontStrikeout="0" fontWeight="50" isExpression="0" fontItalic="0" fontSize="10" blendMode="0" fontSizeMapUnitScale="3x:0,0,0,0,0,0">
            <text-buffer bufferDraw="0" bufferJoinStyle="128" bufferBlendMode="0" bufferSizeUnits="MM" bufferColor="255,255,255,255" bufferOpacity="1" bufferSize="1" bufferNoFill="1" bufferSizeMapUnitScale="3x:0,0,0,0,0,0"/>
            <background shapeRotationType="0" shapeBorderWidth="0" shapeOffsetX="0" shapeRadiiUnit="MM" shapeBorderWidthMapUnitScale="3x:0,0,0,0,0,0" shapeSizeMapUnitScale="3x:0,0,0,0,0,0" shapeOffsetY="0" shapeRadiiMapUnitScale="3x:0,0,0,0,0,0" shapeSizeUnit="MM" shapeFillColor="255,255,255,255" shapeDraw="0" shapeSizeX="0" shapeRadiiY="0" shapeOffsetUnit="MM" shapeOffsetMapUnitScale="3x:0,0,0,0,0,0" shapeBorderColor="128,128,128,255" shapeBorderWidthUnit="MM" shapeRadiiX="0" shapeBlendMode="0" shapeOpacity="1" shapeSizeType="0" shapeType="0" shapeSizeY="0" shapeJoinStyle="64" shapeSVGFile="" shapeRotation="0"/>
            <shadow shadowScale="100" shadowRadiusMapUnitScale="3x:0,0,0,0,0,0" shadowOffsetAngle="135" shadowUnder="0" shadowOffsetMapUnitScale="3x:0,0,0,0,0,0" shadowBlendMode="6" shadowOffsetDist="1" shadowDraw="0" shadowOffsetGlobal="1" shadowRadius="1.5" shadowRadiusUnit="MM" shadowRadiusAlphaOnly="0" shadowOpacity="0.7" shadowOffsetUnit="MM" shadowColor="0,0,0,255"/>
            <substitutions/>
          </text-style>
          <text-format wrapChar="" multilineAlign="3" useMaxLineLengthForAutoWrap="1" rightDirectionSymbol=">" reverseDirectionSymbol="0" autoWrapLength="0" placeDirectionSymbol="0" addDirectionSymbol="0" decimals="3" plussign="0" formatNumbers="0" leftDirectionSymbol="&lt;"/>
          <placement placementFlags="10" priority="5" labelOffsetMapUnitScale="3x:0,0,0,0,0,0" quadOffset="2" maxCurvedCharAngleOut="-25" rotationAngle="0" fitInPolygonOnly="0" repeatDistanceMapUnitScale="3x:0,0,0,0,0,0" predefinedPositionOrder="TR,TL,BR,BL,R,L,TSR,BSR" offsetType="0" centroidInside="0" repeatDistanceUnits="MM" placement="1" preserveRotation="1" xOffset="22" dist="0" centroidWhole="0" offsetUnits="Point" repeatDistance="0" distUnits="MM" maxCurvedCharAngleIn="25" distMapUnitScale="3x:0,0,0,0,0,0" yOffset="-8"/>
          <rendering maxNumLabels="2000" upsidedownLabels="0" obstacle="1" limitNumLabels="0" fontLimitPixelSize="0" minFeatureSize="0" obstacleType="0" displayAll="1" scaleVisibility="1" scaleMin="1" scaleMax="2000" fontMinPixelSize="3" mergeLines="0" fontMaxPixelSize="10000" obstacleFactor="1" drawLabels="1" zIndex="0" labelPerPart="0"/>
          <dd_properties>
            <Option type="Map">
              <Option type="QString" value="" name="name"/>
              <Option name="properties"/>
              <Option type="QString" value="collection" name="type"/>
            </Option>
          </dd_properties>
        </settings>
      </rule>
      <rule scalemindenom="1000" scalemaxdenom="2000" key="{a61fcb23-143c-4a13-a482-096da0d0ee4f}">
        <settings>
          <text-style fontCapitals="0" fontUnderline="0" previewBkgrdColor="#ffffff" fontFamily="MS Shell Dlg 2" namedStyle="Regular" textOpacity="1" multilineHeight="1" fontSizeUnit="Point" useSubstitutions="0" fieldName="rioolput" textColor="0,0,0,255" fontWordSpacing="0" fontLetterSpacing="0" fontStrikeout="0" fontWeight="50" isExpression="0" fontItalic="0" fontSize="10" blendMode="0" fontSizeMapUnitScale="3x:0,0,0,0,0,0">
            <text-buffer bufferDraw="0" bufferJoinStyle="128" bufferBlendMode="0" bufferSizeUnits="MM" bufferColor="255,255,255,255" bufferOpacity="1" bufferSize="1" bufferNoFill="1" bufferSizeMapUnitScale="3x:0,0,0,0,0,0"/>
            <background shapeRotationType="0" shapeBorderWidth="0" shapeOffsetX="0" shapeRadiiUnit="MM" shapeBorderWidthMapUnitScale="3x:0,0,0,0,0,0" shapeSizeMapUnitScale="3x:0,0,0,0,0,0" shapeOffsetY="0" shapeRadiiMapUnitScale="3x:0,0,0,0,0,0" shapeSizeUnit="MM" shapeFillColor="255,255,255,255" shapeDraw="0" shapeSizeX="0" shapeRadiiY="0" shapeOffsetUnit="MM" shapeOffsetMapUnitScale="3x:0,0,0,0,0,0" shapeBorderColor="128,128,128,255" shapeBorderWidthUnit="MM" shapeRadiiX="0" shapeBlendMode="0" shapeOpacity="1" shapeSizeType="0" shapeType="0" shapeSizeY="0" shapeJoinStyle="64" shapeSVGFile="" shapeRotation="0"/>
            <shadow shadowScale="100" shadowRadiusMapUnitScale="3x:0,0,0,0,0,0" shadowOffsetAngle="135" shadowUnder="0" shadowOffsetMapUnitScale="3x:0,0,0,0,0,0" shadowBlendMode="6" shadowOffsetDist="1" shadowDraw="0" shadowOffsetGlobal="1" shadowRadius="1.5" shadowRadiusUnit="MM" shadowRadiusAlphaOnly="0" shadowOpacity="0.7" shadowOffsetUnit="MM" shadowColor="0,0,0,255"/>
            <substitutions/>
          </text-style>
          <text-format wrapChar="" multilineAlign="3" useMaxLineLengthForAutoWrap="1" rightDirectionSymbol=">" reverseDirectionSymbol="0" autoWrapLength="0" placeDirectionSymbol="0" addDirectionSymbol="0" decimals="3" plussign="0" formatNumbers="0" leftDirectionSymbol="&lt;"/>
          <placement placementFlags="10" priority="5" labelOffsetMapUnitScale="3x:0,0,0,0,0,0" quadOffset="2" maxCurvedCharAngleOut="-25" rotationAngle="0" fitInPolygonOnly="0" repeatDistanceMapUnitScale="3x:0,0,0,0,0,0" predefinedPositionOrder="TR,TL,BR,BL,R,L,TSR,BSR" offsetType="0" centroidInside="0" repeatDistanceUnits="MM" placement="1" preserveRotation="1" xOffset="4" dist="0" centroidWhole="0" offsetUnits="Point" repeatDistance="0" distUnits="MM" maxCurvedCharAngleIn="25" distMapUnitScale="3x:0,0,0,0,0,0" yOffset="-2"/>
          <rendering maxNumLabels="2000" upsidedownLabels="0" obstacle="1" limitNumLabels="0" fontLimitPixelSize="0" minFeatureSize="0" obstacleType="0" displayAll="1" scaleVisibility="1" scaleMin="1" scaleMax="2000" fontMinPixelSize="3" mergeLines="0" fontMaxPixelSize="10000" obstacleFactor="1" drawLabels="1" zIndex="0" labelPerPart="0"/>
          <dd_properties>
            <Option type="Map">
              <Option type="QString" value="" name="name"/>
              <Option name="properties"/>
              <Option type="QString" value="collection" name="type"/>
            </Option>
          </dd_properties>
        </settings>
      </rule>
    </rules>
  </labeling>
  <blendMode>0</blendMode>
  <featureBlendMode>0</featureBlendMode>
  <layerGeometryType>0</layerGeometryType>
</qgis>
