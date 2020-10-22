<!DOCTYPE qgis PUBLIC 'http://mrcc.com/qgis.dtd' 'SYSTEM'>
<qgis version="3.8.0-Zanzibar" labelsEnabled="1" styleCategories="AllStyleCategories" minScale="0" readOnly="0" hasScaleBasedVisibilityFlag="0" simplifyAlgorithm="0" simplifyDrawingHints="1" simplifyMaxScale="1" maxScale="0" simplifyDrawingTol="1" simplifyLocal="1">
  <flags>
    <Identifiable>1</Identifiable>
    <Removable>1</Removable>
    <Searchable>1</Searchable>
  </flags>
  <renderer-v2 type="RuleRenderer" forceraster="0" enableorderby="0" symbollevels="0">
    <rules key="{e4438d9a-7f72-4911-a6be-6292c7ad2e68}">
      <rule scalemindenom="1" filter="&quot;type_knooppunt&quot; = 'inspectieput'" key="{74bfc7d4-f299-4d26-9fee-bb4f9b43006b}" symbol="0" label="inspectieput" scalemaxdenom="5000"/>
      <rule scalemindenom="1" filter="&quot;type_knooppunt&quot; = 'pomp'" key="{c2277bf1-0a02-4dfe-b668-1745bc72b629}" symbol="1" label="pomp" scalemaxdenom="5000"/>
      <rule scalemindenom="1" filter="&quot;type_knooppunt&quot; = 'uitlaat'" key="{28be3702-c2ce-46e3-8bf4-798fd27398cc}" symbol="2" label="uitlaat" scalemaxdenom="5000"/>
    </rules>
    <symbols>
      <symbol type="marker" alpha="1" clip_to_extent="1" force_rhr="0" name="0">
        <layer pass="0" enabled="1" class="SimpleMarker" locked="0">
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
      <symbol type="marker" alpha="1" clip_to_extent="1" force_rhr="0" name="1">
        <layer pass="0" enabled="1" class="SimpleMarker" locked="0">
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
      <symbol type="marker" alpha="1" clip_to_extent="1" force_rhr="0" name="2">
        <layer pass="0" enabled="1" class="SimpleMarker" locked="0">
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
    <rules key="{e07e34cb-effe-41e2-8998-29c2f6e09608}">
      <rule scalemindenom="1" key="{f3c15924-385f-43f7-a35a-95e4d5cd7797}" scalemaxdenom="1000">
        <settings>
          <text-style fontSizeUnit="Point" fontUnderline="0" fontSize="10" fontStrikeout="0" useSubstitutions="0" previewBkgrdColor="#ffffff" fontFamily="MS Shell Dlg 2" namedStyle="Regular" blendMode="0" fontWordSpacing="0" fontCapitals="0" textOpacity="1" fontItalic="0" textColor="0,0,0,255" isExpression="0" fontSizeMapUnitScale="3x:0,0,0,0,0,0" fieldName="rioolput" fontWeight="50" multilineHeight="1" fontLetterSpacing="0">
            <text-buffer bufferDraw="0" bufferBlendMode="0" bufferSizeMapUnitScale="3x:0,0,0,0,0,0" bufferJoinStyle="128" bufferSizeUnits="MM" bufferOpacity="1" bufferColor="255,255,255,255" bufferNoFill="1" bufferSize="1"/>
            <background shapeDraw="0" shapeSizeX="0" shapeRadiiX="0" shapeOpacity="1" shapeSizeType="0" shapeRadiiUnit="MM" shapeOffsetMapUnitScale="3x:0,0,0,0,0,0" shapeType="0" shapeRotationType="0" shapeBorderWidth="0" shapeSizeY="0" shapeBorderColor="128,128,128,255" shapeOffsetUnit="MM" shapeRotation="0" shapeBorderWidthMapUnitScale="3x:0,0,0,0,0,0" shapeBorderWidthUnit="MM" shapeOffsetX="0" shapeSizeMapUnitScale="3x:0,0,0,0,0,0" shapeSizeUnit="MM" shapeFillColor="255,255,255,255" shapeJoinStyle="64" shapeRadiiY="0" shapeRadiiMapUnitScale="3x:0,0,0,0,0,0" shapeOffsetY="0" shapeBlendMode="0" shapeSVGFile=""/>
            <shadow shadowOffsetAngle="135" shadowOffsetDist="1" shadowOffsetMapUnitScale="3x:0,0,0,0,0,0" shadowOpacity="0.7" shadowOffsetUnit="MM" shadowRadiusUnit="MM" shadowColor="0,0,0,255" shadowDraw="0" shadowRadiusAlphaOnly="0" shadowUnder="0" shadowRadius="1.5" shadowOffsetGlobal="1" shadowScale="100" shadowBlendMode="6" shadowRadiusMapUnitScale="3x:0,0,0,0,0,0"/>
            <substitutions/>
          </text-style>
          <text-format rightDirectionSymbol=">" wrapChar="" multilineAlign="3" addDirectionSymbol="0" decimals="3" plussign="0" reverseDirectionSymbol="0" autoWrapLength="0" leftDirectionSymbol="&lt;" useMaxLineLengthForAutoWrap="1" formatNumbers="0" placeDirectionSymbol="0"/>
          <placement maxCurvedCharAngleIn="25" dist="0" predefinedPositionOrder="TR,TL,BR,BL,R,L,TSR,BSR" repeatDistance="0" geometryGeneratorType="PointGeometry" xOffset="22" repeatDistanceMapUnitScale="3x:0,0,0,0,0,0" fitInPolygonOnly="0" maxCurvedCharAngleOut="-25" centroidWhole="0" quadOffset="2" repeatDistanceUnits="MM" priority="5" centroidInside="0" geometryGeneratorEnabled="0" placementFlags="10" offsetUnits="Point" preserveRotation="1" yOffset="-8" labelOffsetMapUnitScale="3x:0,0,0,0,0,0" distMapUnitScale="3x:0,0,0,0,0,0" placement="1" offsetType="0" distUnits="MM" rotationAngle="0" geometryGenerator=""/>
          <rendering labelPerPart="0" obstacle="1" obstacleFactor="1" drawLabels="1" minFeatureSize="0" scaleVisibility="1" maxNumLabels="2000" scaleMin="1" limitNumLabels="0" fontMinPixelSize="3" displayAll="1" upsidedownLabels="0" zIndex="0" fontMaxPixelSize="10000" fontLimitPixelSize="0" mergeLines="0" obstacleType="0" scaleMax="2000"/>
          <dd_properties>
            <Option type="Map">
              <Option type="QString" value="" name="name"/>
              <Option name="properties"/>
              <Option type="QString" value="collection" name="type"/>
            </Option>
          </dd_properties>
        </settings>
      </rule>
      <rule scalemindenom="1000" key="{b8014d9d-ebbb-4276-8bed-e64d4a543ff8}" scalemaxdenom="2000">
        <settings>
          <text-style fontSizeUnit="Point" fontUnderline="0" fontSize="10" fontStrikeout="0" useSubstitutions="0" previewBkgrdColor="#ffffff" fontFamily="MS Shell Dlg 2" namedStyle="Regular" blendMode="0" fontWordSpacing="0" fontCapitals="0" textOpacity="1" fontItalic="0" textColor="0,0,0,255" isExpression="0" fontSizeMapUnitScale="3x:0,0,0,0,0,0" fieldName="rioolput" fontWeight="50" multilineHeight="1" fontLetterSpacing="0">
            <text-buffer bufferDraw="0" bufferBlendMode="0" bufferSizeMapUnitScale="3x:0,0,0,0,0,0" bufferJoinStyle="128" bufferSizeUnits="MM" bufferOpacity="1" bufferColor="255,255,255,255" bufferNoFill="1" bufferSize="1"/>
            <background shapeDraw="0" shapeSizeX="0" shapeRadiiX="0" shapeOpacity="1" shapeSizeType="0" shapeRadiiUnit="MM" shapeOffsetMapUnitScale="3x:0,0,0,0,0,0" shapeType="0" shapeRotationType="0" shapeBorderWidth="0" shapeSizeY="0" shapeBorderColor="128,128,128,255" shapeOffsetUnit="MM" shapeRotation="0" shapeBorderWidthMapUnitScale="3x:0,0,0,0,0,0" shapeBorderWidthUnit="MM" shapeOffsetX="0" shapeSizeMapUnitScale="3x:0,0,0,0,0,0" shapeSizeUnit="MM" shapeFillColor="255,255,255,255" shapeJoinStyle="64" shapeRadiiY="0" shapeRadiiMapUnitScale="3x:0,0,0,0,0,0" shapeOffsetY="0" shapeBlendMode="0" shapeSVGFile=""/>
            <shadow shadowOffsetAngle="135" shadowOffsetDist="1" shadowOffsetMapUnitScale="3x:0,0,0,0,0,0" shadowOpacity="0.7" shadowOffsetUnit="MM" shadowRadiusUnit="MM" shadowColor="0,0,0,255" shadowDraw="0" shadowRadiusAlphaOnly="0" shadowUnder="0" shadowRadius="1.5" shadowOffsetGlobal="1" shadowScale="100" shadowBlendMode="6" shadowRadiusMapUnitScale="3x:0,0,0,0,0,0"/>
            <substitutions/>
          </text-style>
          <text-format rightDirectionSymbol=">" wrapChar="" multilineAlign="3" addDirectionSymbol="0" decimals="3" plussign="0" reverseDirectionSymbol="0" autoWrapLength="0" leftDirectionSymbol="&lt;" useMaxLineLengthForAutoWrap="1" formatNumbers="0" placeDirectionSymbol="0"/>
          <placement maxCurvedCharAngleIn="25" dist="0" predefinedPositionOrder="TR,TL,BR,BL,R,L,TSR,BSR" repeatDistance="0" geometryGeneratorType="PointGeometry" xOffset="4" repeatDistanceMapUnitScale="3x:0,0,0,0,0,0" fitInPolygonOnly="0" maxCurvedCharAngleOut="-25" centroidWhole="0" quadOffset="2" repeatDistanceUnits="MM" priority="5" centroidInside="0" geometryGeneratorEnabled="0" placementFlags="10" offsetUnits="Point" preserveRotation="1" yOffset="-2" labelOffsetMapUnitScale="3x:0,0,0,0,0,0" distMapUnitScale="3x:0,0,0,0,0,0" placement="1" offsetType="0" distUnits="MM" rotationAngle="0" geometryGenerator=""/>
          <rendering labelPerPart="0" obstacle="1" obstacleFactor="1" drawLabels="1" minFeatureSize="0" scaleVisibility="1" maxNumLabels="2000" scaleMin="1" limitNumLabels="0" fontMinPixelSize="3" displayAll="1" upsidedownLabels="0" zIndex="0" fontMaxPixelSize="10000" fontLimitPixelSize="0" mergeLines="0" obstacleType="0" scaleMax="2000"/>
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
    <field name="rioolput">
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
    <field name="vorm">
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
    <field name="lengte">
      <editWidget type="">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="type_knooppunt">
      <editWidget type="">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="bodemhoogte">
      <editWidget type="">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="maaiveldhoogte">
      <editWidget type="">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
  </fieldConfiguration>
  <aliases>
    <alias field="id" name="" index="0"/>
    <alias field="rioolput" name="" index="1"/>
    <alias field="threedi_id" name="" index="2"/>
    <alias field="vorm" name="" index="3"/>
    <alias field="breedte" name="" index="4"/>
    <alias field="lengte" name="" index="5"/>
    <alias field="type_knooppunt" name="" index="6"/>
    <alias field="bodemhoogte" name="" index="7"/>
    <alias field="maaiveldhoogte" name="" index="8"/>
  </aliases>
  <excludeAttributesWMS/>
  <excludeAttributesWFS/>
  <defaults>
    <default field="id" applyOnUpdate="0" expression=""/>
    <default field="rioolput" applyOnUpdate="0" expression=""/>
    <default field="threedi_id" applyOnUpdate="0" expression=""/>
    <default field="vorm" applyOnUpdate="0" expression=""/>
    <default field="breedte" applyOnUpdate="0" expression=""/>
    <default field="lengte" applyOnUpdate="0" expression=""/>
    <default field="type_knooppunt" applyOnUpdate="0" expression=""/>
    <default field="bodemhoogte" applyOnUpdate="0" expression=""/>
    <default field="maaiveldhoogte" applyOnUpdate="0" expression=""/>
  </defaults>
  <constraints>
    <constraint unique_strength="1" exp_strength="0" constraints="3" field="id" notnull_strength="1"/>
    <constraint unique_strength="0" exp_strength="0" constraints="0" field="rioolput" notnull_strength="0"/>
    <constraint unique_strength="0" exp_strength="0" constraints="0" field="threedi_id" notnull_strength="0"/>
    <constraint unique_strength="0" exp_strength="0" constraints="0" field="vorm" notnull_strength="0"/>
    <constraint unique_strength="0" exp_strength="0" constraints="0" field="breedte" notnull_strength="0"/>
    <constraint unique_strength="0" exp_strength="0" constraints="0" field="lengte" notnull_strength="0"/>
    <constraint unique_strength="0" exp_strength="0" constraints="0" field="type_knooppunt" notnull_strength="0"/>
    <constraint unique_strength="0" exp_strength="0" constraints="0" field="bodemhoogte" notnull_strength="0"/>
    <constraint unique_strength="0" exp_strength="0" constraints="0" field="maaiveldhoogte" notnull_strength="0"/>
  </constraints>
  <constraintExpressions>
    <constraint desc="" exp="" field="id"/>
    <constraint desc="" exp="" field="rioolput"/>
    <constraint desc="" exp="" field="threedi_id"/>
    <constraint desc="" exp="" field="vorm"/>
    <constraint desc="" exp="" field="breedte"/>
    <constraint desc="" exp="" field="lengte"/>
    <constraint desc="" exp="" field="type_knooppunt"/>
    <constraint desc="" exp="" field="bodemhoogte"/>
    <constraint desc="" exp="" field="maaiveldhoogte"/>
  </constraintExpressions>
  <expressionfields/>
  <attributeactions/>
  <attributetableconfig sortOrder="0" sortExpression="" actionWidgetStyle="dropDown">
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
