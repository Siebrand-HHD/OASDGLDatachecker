<!DOCTYPE qgis PUBLIC 'http://mrcc.com/qgis.dtd' 'SYSTEM'>
<qgis labelsEnabled="1" version="3.4.15-Madeira" styleCategories="Symbology|Labeling">
  <renderer-v2 type="RuleRenderer" symbollevels="0" enableorderby="0" forceraster="0">
    <rules key="{e4438d9a-7f72-4911-a6be-6292c7ad2e68}">
      <rule symbol="0" filter="&quot;type_knooppunt&quot; = 'inspectieput'" scalemaxdenom="5000" scalemindenom="1" label="inspectieput" key="{74bfc7d4-f299-4d26-9fee-bb4f9b43006b}"/>
      <rule symbol="1" filter="&quot;type_knooppunt&quot; = 'pomp'" scalemaxdenom="5000" scalemindenom="1" label="pomp" key="{c2277bf1-0a02-4dfe-b668-1745bc72b629}"/>
      <rule symbol="2" filter="&quot;type_knooppunt&quot; = 'uitlaat'" scalemaxdenom="5000" scalemindenom="1" label="uitlaat" key="{28be3702-c2ce-46e3-8bf4-798fd27398cc}"/>
    </rules>
    <symbols>
      <symbol force_rhr="0" clip_to_extent="1" type="marker" name="0" alpha="1">
        <layer enabled="1" pass="0" locked="0" class="SimpleMarker">
          <prop k="angle" v="0"/>
          <prop k="color" v="255,255,255,255"/>
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
              <Option type="QString" name="name" value=""/>
              <Option type="Map" name="properties">
                <Option type="Map" name="angle">
                  <Option type="bool" name="active" value="false"/>
                  <Option type="QString" name="expression" value="angle_at_vertex( geometry(get_feature('leiding', 'beginpuntleiding', rioolput)),0)"/>
                  <Option type="int" name="type" value="3"/>
                </Option>
              </Option>
              <Option type="QString" name="type" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol force_rhr="0" clip_to_extent="1" type="marker" name="1" alpha="1">
        <layer enabled="1" pass="0" locked="0" class="SimpleMarker">
          <prop k="angle" v="0"/>
          <prop k="color" v="255,255,255,255"/>
          <prop k="horizontal_anchor_point" v="1"/>
          <prop k="joinstyle" v="bevel"/>
          <prop k="name" v="pentagon"/>
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
              <Option type="QString" name="name" value=""/>
              <Option name="properties"/>
              <Option type="QString" name="type" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol force_rhr="0" clip_to_extent="1" type="marker" name="2" alpha="1">
        <layer enabled="1" pass="0" locked="0" class="SimpleMarker">
          <prop k="angle" v="0"/>
          <prop k="color" v="255,255,255,255"/>
          <prop k="horizontal_anchor_point" v="1"/>
          <prop k="joinstyle" v="bevel"/>
          <prop k="name" v="triangle"/>
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
              <Option type="QString" name="name" value=""/>
              <Option name="properties"/>
              <Option type="QString" name="type" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
    </symbols>
  </renderer-v2>
  <labeling type="rule-based">
    <rules key="{e07e34cb-effe-41e2-8998-29c2f6e09608}">
      <rule scalemaxdenom="1000" scalemindenom="1" key="{f3c15924-385f-43f7-a35a-95e4d5cd7797}">
        <settings>
          <text-style fontItalic="0" useSubstitutions="0" fontWordSpacing="0" textColor="0,0,0,255" previewBkgrdColor="#ffffff" fontWeight="50" fontUnderline="0" fontSizeMapUnitScale="3x:0,0,0,0,0,0" fontSize="10" blendMode="0" fieldName="rioolput" namedStyle="Regular" multilineHeight="1" fontLetterSpacing="0" isExpression="0" textOpacity="1" fontStrikeout="0" fontSizeUnit="Point" fontFamily="MS Shell Dlg 2" fontCapitals="0">
            <text-buffer bufferOpacity="1" bufferBlendMode="0" bufferSizeMapUnitScale="3x:0,0,0,0,0,0" bufferColor="255,255,255,255" bufferSize="1" bufferSizeUnits="MM" bufferJoinStyle="128" bufferDraw="0" bufferNoFill="1"/>
            <background shapeOpacity="1" shapeSizeUnit="MM" shapeRadiiX="0" shapeBorderWidthMapUnitScale="3x:0,0,0,0,0,0" shapeJoinStyle="64" shapeBorderWidth="0" shapeOffsetMapUnitScale="3x:0,0,0,0,0,0" shapeSizeY="0" shapeRotation="0" shapeBorderWidthUnit="MM" shapeSizeMapUnitScale="3x:0,0,0,0,0,0" shapeRadiiUnit="MM" shapeFillColor="255,255,255,255" shapeOffsetX="0" shapeOffsetY="0" shapeSizeX="0" shapeSizeType="0" shapeDraw="0" shapeOffsetUnit="MM" shapeType="0" shapeRadiiY="0" shapeRadiiMapUnitScale="3x:0,0,0,0,0,0" shapeBorderColor="128,128,128,255" shapeSVGFile="" shapeRotationType="0" shapeBlendMode="0"/>
            <shadow shadowOffsetUnit="MM" shadowScale="100" shadowBlendMode="6" shadowColor="0,0,0,255" shadowRadius="1.5" shadowOffsetDist="1" shadowOffsetMapUnitScale="3x:0,0,0,0,0,0" shadowOpacity="0.7" shadowRadiusMapUnitScale="3x:0,0,0,0,0,0" shadowRadiusAlphaOnly="0" shadowRadiusUnit="MM" shadowDraw="0" shadowUnder="0" shadowOffsetAngle="135" shadowOffsetGlobal="1"/>
            <substitutions/>
          </text-style>
          <text-format addDirectionSymbol="0" placeDirectionSymbol="0" autoWrapLength="0" leftDirectionSymbol="&lt;" rightDirectionSymbol=">" wrapChar="" multilineAlign="3" reverseDirectionSymbol="0" formatNumbers="0" decimals="3" useMaxLineLengthForAutoWrap="1" plussign="0"/>
          <placement centroidInside="0" fitInPolygonOnly="0" offsetUnits="Point" repeatDistanceUnits="MM" predefinedPositionOrder="TR,TL,BR,BL,R,L,TSR,BSR" xOffset="22" placement="1" preserveRotation="1" distMapUnitScale="3x:0,0,0,0,0,0" rotationAngle="0" yOffset="-8" centroidWhole="0" priority="5" labelOffsetMapUnitScale="3x:0,0,0,0,0,0" maxCurvedCharAngleIn="25" maxCurvedCharAngleOut="-25" quadOffset="2" repeatDistanceMapUnitScale="3x:0,0,0,0,0,0" dist="0" distUnits="MM" offsetType="0" repeatDistance="0" placementFlags="10"/>
          <rendering scaleMax="2000" obstacleType="0" maxNumLabels="2000" labelPerPart="0" drawLabels="1" upsidedownLabels="0" fontLimitPixelSize="0" minFeatureSize="0" scaleVisibility="1" scaleMin="1" limitNumLabels="0" zIndex="0" fontMinPixelSize="3" mergeLines="0" displayAll="1" obstacleFactor="1" obstacle="1" fontMaxPixelSize="10000"/>
          <dd_properties>
            <Option type="Map">
              <Option type="QString" name="name" value=""/>
              <Option name="properties"/>
              <Option type="QString" name="type" value="collection"/>
            </Option>
          </dd_properties>
        </settings>
      </rule>
      <rule scalemaxdenom="2000" scalemindenom="1000" key="{b8014d9d-ebbb-4276-8bed-e64d4a543ff8}">
        <settings>
          <text-style fontItalic="0" useSubstitutions="0" fontWordSpacing="0" textColor="0,0,0,255" previewBkgrdColor="#ffffff" fontWeight="50" fontUnderline="0" fontSizeMapUnitScale="3x:0,0,0,0,0,0" fontSize="10" blendMode="0" fieldName="rioolput" namedStyle="Regular" multilineHeight="1" fontLetterSpacing="0" isExpression="0" textOpacity="1" fontStrikeout="0" fontSizeUnit="Point" fontFamily="MS Shell Dlg 2" fontCapitals="0">
            <text-buffer bufferOpacity="1" bufferBlendMode="0" bufferSizeMapUnitScale="3x:0,0,0,0,0,0" bufferColor="255,255,255,255" bufferSize="1" bufferSizeUnits="MM" bufferJoinStyle="128" bufferDraw="0" bufferNoFill="1"/>
            <background shapeOpacity="1" shapeSizeUnit="MM" shapeRadiiX="0" shapeBorderWidthMapUnitScale="3x:0,0,0,0,0,0" shapeJoinStyle="64" shapeBorderWidth="0" shapeOffsetMapUnitScale="3x:0,0,0,0,0,0" shapeSizeY="0" shapeRotation="0" shapeBorderWidthUnit="MM" shapeSizeMapUnitScale="3x:0,0,0,0,0,0" shapeRadiiUnit="MM" shapeFillColor="255,255,255,255" shapeOffsetX="0" shapeOffsetY="0" shapeSizeX="0" shapeSizeType="0" shapeDraw="0" shapeOffsetUnit="MM" shapeType="0" shapeRadiiY="0" shapeRadiiMapUnitScale="3x:0,0,0,0,0,0" shapeBorderColor="128,128,128,255" shapeSVGFile="" shapeRotationType="0" shapeBlendMode="0"/>
            <shadow shadowOffsetUnit="MM" shadowScale="100" shadowBlendMode="6" shadowColor="0,0,0,255" shadowRadius="1.5" shadowOffsetDist="1" shadowOffsetMapUnitScale="3x:0,0,0,0,0,0" shadowOpacity="0.7" shadowRadiusMapUnitScale="3x:0,0,0,0,0,0" shadowRadiusAlphaOnly="0" shadowRadiusUnit="MM" shadowDraw="0" shadowUnder="0" shadowOffsetAngle="135" shadowOffsetGlobal="1"/>
            <substitutions/>
          </text-style>
          <text-format addDirectionSymbol="0" placeDirectionSymbol="0" autoWrapLength="0" leftDirectionSymbol="&lt;" rightDirectionSymbol=">" wrapChar="" multilineAlign="3" reverseDirectionSymbol="0" formatNumbers="0" decimals="3" useMaxLineLengthForAutoWrap="1" plussign="0"/>
          <placement centroidInside="0" fitInPolygonOnly="0" offsetUnits="Point" repeatDistanceUnits="MM" predefinedPositionOrder="TR,TL,BR,BL,R,L,TSR,BSR" xOffset="4" placement="1" preserveRotation="1" distMapUnitScale="3x:0,0,0,0,0,0" rotationAngle="0" yOffset="-2" centroidWhole="0" priority="5" labelOffsetMapUnitScale="3x:0,0,0,0,0,0" maxCurvedCharAngleIn="25" maxCurvedCharAngleOut="-25" quadOffset="2" repeatDistanceMapUnitScale="3x:0,0,0,0,0,0" dist="0" distUnits="MM" offsetType="0" repeatDistance="0" placementFlags="10"/>
          <rendering scaleMax="2000" obstacleType="0" maxNumLabels="2000" labelPerPart="0" drawLabels="1" upsidedownLabels="0" fontLimitPixelSize="0" minFeatureSize="0" scaleVisibility="1" scaleMin="1" limitNumLabels="0" zIndex="0" fontMinPixelSize="3" mergeLines="0" displayAll="1" obstacleFactor="1" obstacle="1" fontMaxPixelSize="10000"/>
          <dd_properties>
            <Option type="Map">
              <Option type="QString" name="name" value=""/>
              <Option name="properties"/>
              <Option type="QString" name="type" value="collection"/>
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
