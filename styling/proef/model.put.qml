<!DOCTYPE qgis PUBLIC 'http://mrcc.com/qgis.dtd' 'SYSTEM'>
<qgis labelsEnabled="1" simplifyDrawingHints="1" maxScale="0" simplifyAlgorithm="0" styleCategories="AllStyleCategories" hasScaleBasedVisibilityFlag="0" simplifyDrawingTol="1" simplifyMaxScale="1" minScale="0" version="3.8.0-Zanzibar" simplifyLocal="1" readOnly="0">
  <flags>
    <Identifiable>1</Identifiable>
    <Removable>1</Removable>
    <Searchable>1</Searchable>
  </flags>
  <renderer-v2 symbollevels="0" enableorderby="0" forceraster="0" type="RuleRenderer">
    <rules key="{e4438d9a-7f72-4911-a6be-6292c7ad2e68}">
      <rule scalemindenom="1" scalemaxdenom="5000" label="inspectieput" key="{74bfc7d4-f299-4d26-9fee-bb4f9b43006b}" symbol="0" filter="&quot;type_knooppunt&quot; = 'inspectieput'"/>
      <rule scalemindenom="1" scalemaxdenom="5000" label="pomp" key="{c2277bf1-0a02-4dfe-b668-1745bc72b629}" symbol="1" filter="&quot;type_knooppunt&quot; = 'pomp'"/>
      <rule scalemindenom="1" scalemaxdenom="5000" label="uitlaat" key="{28be3702-c2ce-46e3-8bf4-798fd27398cc}" symbol="2" filter="&quot;type_knooppunt&quot; = 'uitlaat'"/>
    </rules>
    <symbols>
      <symbol name="0" force_rhr="0" clip_to_extent="1" alpha="1" type="marker">
        <layer pass="0" locked="0" class="SimpleMarker" enabled="1">
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
          <prop k="size" v="1"/>
          <prop k="size_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="size_unit" v="MM"/>
          <prop k="vertical_anchor_point" v="1"/>
          <data_defined_properties>
            <Option type="Map">
              <Option name="name" type="QString" value=""/>
              <Option name="properties" type="Map">
                <Option name="angle" type="Map">
                  <Option name="active" type="bool" value="false"/>
                  <Option name="expression" type="QString" value="angle_at_vertex( geometry(get_feature('leiding', 'beginpuntleiding', rioolput)),0)"/>
                  <Option name="type" type="int" value="3"/>
                </Option>
              </Option>
              <Option name="type" type="QString" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol name="1" force_rhr="0" clip_to_extent="1" alpha="1" type="marker">
        <layer pass="0" locked="0" class="SimpleMarker" enabled="1">
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
              <Option name="name" type="QString" value=""/>
              <Option name="properties"/>
              <Option name="type" type="QString" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol name="2" force_rhr="0" clip_to_extent="1" alpha="1" type="marker">
        <layer pass="0" locked="0" class="SimpleMarker" enabled="1">
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
              <Option name="name" type="QString" value=""/>
              <Option name="properties"/>
              <Option name="type" type="QString" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
    </symbols>
  </renderer-v2>
  <labeling type="rule-based">
    <rules key="{e07e34cb-effe-41e2-8998-29c2f6e09608}">
      <rule scalemindenom="1" scalemaxdenom="1000" key="{f3c15924-385f-43f7-a35a-95e4d5cd7797}">
        <settings>
          <text-style fontSizeMapUnitScale="3x:0,0,0,0,0,0" fontSize="10" fontWeight="50" namedStyle="Regular" blendMode="0" isExpression="0" previewBkgrdColor="#ffffff" fontLetterSpacing="0" fontSizeUnit="Point" fieldName="rioolput" fontItalic="0" textColor="0,0,0,255" fontCapitals="0" useSubstitutions="0" fontFamily="MS Shell Dlg 2" multilineHeight="1" fontStrikeout="0" fontUnderline="0" fontWordSpacing="0" textOpacity="1">
            <text-buffer bufferSizeUnits="MM" bufferJoinStyle="128" bufferNoFill="1" bufferOpacity="1" bufferColor="255,255,255,255" bufferBlendMode="0" bufferDraw="0" bufferSizeMapUnitScale="3x:0,0,0,0,0,0" bufferSize="1"/>
            <background shapeOffsetUnit="MM" shapeRadiiY="0" shapeSizeUnit="MM" shapeFillColor="255,255,255,255" shapeRadiiMapUnitScale="3x:0,0,0,0,0,0" shapeBorderWidth="0" shapeOffsetY="0" shapeSizeMapUnitScale="3x:0,0,0,0,0,0" shapeDraw="0" shapeBorderColor="128,128,128,255" shapeSizeY="0" shapeBorderWidthUnit="MM" shapeRadiiUnit="MM" shapeJoinStyle="64" shapeRotation="0" shapeRadiiX="0" shapeSizeX="0" shapeRotationType="0" shapeSizeType="0" shapeBlendMode="0" shapeOffsetX="0" shapeOpacity="1" shapeOffsetMapUnitScale="3x:0,0,0,0,0,0" shapeType="0" shapeSVGFile="" shapeBorderWidthMapUnitScale="3x:0,0,0,0,0,0"/>
            <shadow shadowUnder="0" shadowOffsetMapUnitScale="3x:0,0,0,0,0,0" shadowBlendMode="6" shadowRadiusAlphaOnly="0" shadowOffsetAngle="135" shadowRadiusUnit="MM" shadowRadiusMapUnitScale="3x:0,0,0,0,0,0" shadowColor="0,0,0,255" shadowDraw="0" shadowOffsetUnit="MM" shadowOffsetDist="1" shadowOpacity="0.7" shadowRadius="1.5" shadowOffsetGlobal="1" shadowScale="100"/>
            <substitutions/>
          </text-style>
          <text-format autoWrapLength="0" addDirectionSymbol="0" leftDirectionSymbol="&lt;" reverseDirectionSymbol="0" useMaxLineLengthForAutoWrap="1" formatNumbers="0" decimals="3" plussign="0" multilineAlign="3" wrapChar="" rightDirectionSymbol=">" placeDirectionSymbol="0"/>
          <placement predefinedPositionOrder="TR,TL,BR,BL,R,L,TSR,BSR" geometryGenerator="" offsetType="0" centroidWhole="0" distUnits="MM" quadOffset="2" placement="1" distMapUnitScale="3x:0,0,0,0,0,0" geometryGeneratorType="PointGeometry" fitInPolygonOnly="0" centroidInside="0" preserveRotation="1" repeatDistanceUnits="MM" yOffset="-8" dist="0" offsetUnits="Point" placementFlags="10" xOffset="22" repeatDistanceMapUnitScale="3x:0,0,0,0,0,0" maxCurvedCharAngleOut="-25" priority="5" repeatDistance="0" rotationAngle="0" maxCurvedCharAngleIn="25" labelOffsetMapUnitScale="3x:0,0,0,0,0,0" geometryGeneratorEnabled="0"/>
          <rendering scaleMax="2000" displayAll="1" zIndex="0" scaleMin="1" obstacle="1" drawLabels="1" obstacleType="0" upsidedownLabels="0" obstacleFactor="1" scaleVisibility="1" labelPerPart="0" minFeatureSize="0" fontLimitPixelSize="0" fontMaxPixelSize="10000" mergeLines="0" maxNumLabels="2000" limitNumLabels="0" fontMinPixelSize="3"/>
          <dd_properties>
            <Option type="Map">
              <Option name="name" type="QString" value=""/>
              <Option name="properties"/>
              <Option name="type" type="QString" value="collection"/>
            </Option>
          </dd_properties>
        </settings>
      </rule>
      <rule scalemindenom="1000" scalemaxdenom="2000" key="{b8014d9d-ebbb-4276-8bed-e64d4a543ff8}">
        <settings>
          <text-style fontSizeMapUnitScale="3x:0,0,0,0,0,0" fontSize="10" fontWeight="50" namedStyle="Regular" blendMode="0" isExpression="0" previewBkgrdColor="#ffffff" fontLetterSpacing="0" fontSizeUnit="Point" fieldName="rioolput" fontItalic="0" textColor="0,0,0,255" fontCapitals="0" useSubstitutions="0" fontFamily="MS Shell Dlg 2" multilineHeight="1" fontStrikeout="0" fontUnderline="0" fontWordSpacing="0" textOpacity="1">
            <text-buffer bufferSizeUnits="MM" bufferJoinStyle="128" bufferNoFill="1" bufferOpacity="1" bufferColor="255,255,255,255" bufferBlendMode="0" bufferDraw="0" bufferSizeMapUnitScale="3x:0,0,0,0,0,0" bufferSize="1"/>
            <background shapeOffsetUnit="MM" shapeRadiiY="0" shapeSizeUnit="MM" shapeFillColor="255,255,255,255" shapeRadiiMapUnitScale="3x:0,0,0,0,0,0" shapeBorderWidth="0" shapeOffsetY="0" shapeSizeMapUnitScale="3x:0,0,0,0,0,0" shapeDraw="0" shapeBorderColor="128,128,128,255" shapeSizeY="0" shapeBorderWidthUnit="MM" shapeRadiiUnit="MM" shapeJoinStyle="64" shapeRotation="0" shapeRadiiX="0" shapeSizeX="0" shapeRotationType="0" shapeSizeType="0" shapeBlendMode="0" shapeOffsetX="0" shapeOpacity="1" shapeOffsetMapUnitScale="3x:0,0,0,0,0,0" shapeType="0" shapeSVGFile="" shapeBorderWidthMapUnitScale="3x:0,0,0,0,0,0"/>
            <shadow shadowUnder="0" shadowOffsetMapUnitScale="3x:0,0,0,0,0,0" shadowBlendMode="6" shadowRadiusAlphaOnly="0" shadowOffsetAngle="135" shadowRadiusUnit="MM" shadowRadiusMapUnitScale="3x:0,0,0,0,0,0" shadowColor="0,0,0,255" shadowDraw="0" shadowOffsetUnit="MM" shadowOffsetDist="1" shadowOpacity="0.7" shadowRadius="1.5" shadowOffsetGlobal="1" shadowScale="100"/>
            <substitutions/>
          </text-style>
          <text-format autoWrapLength="0" addDirectionSymbol="0" leftDirectionSymbol="&lt;" reverseDirectionSymbol="0" useMaxLineLengthForAutoWrap="1" formatNumbers="0" decimals="3" plussign="0" multilineAlign="3" wrapChar="" rightDirectionSymbol=">" placeDirectionSymbol="0"/>
          <placement predefinedPositionOrder="TR,TL,BR,BL,R,L,TSR,BSR" geometryGenerator="" offsetType="0" centroidWhole="0" distUnits="MM" quadOffset="2" placement="1" distMapUnitScale="3x:0,0,0,0,0,0" geometryGeneratorType="PointGeometry" fitInPolygonOnly="0" centroidInside="0" preserveRotation="1" repeatDistanceUnits="MM" yOffset="-2" dist="0" offsetUnits="Point" placementFlags="10" xOffset="4" repeatDistanceMapUnitScale="3x:0,0,0,0,0,0" maxCurvedCharAngleOut="-25" priority="5" repeatDistance="0" rotationAngle="0" maxCurvedCharAngleIn="25" labelOffsetMapUnitScale="3x:0,0,0,0,0,0" geometryGeneratorEnabled="0"/>
          <rendering scaleMax="2000" displayAll="1" zIndex="0" scaleMin="1" obstacle="1" drawLabels="1" obstacleType="0" upsidedownLabels="0" obstacleFactor="1" scaleVisibility="1" labelPerPart="0" minFeatureSize="0" fontLimitPixelSize="0" fontMaxPixelSize="10000" mergeLines="0" maxNumLabels="2000" limitNumLabels="0" fontMinPixelSize="3"/>
          <dd_properties>
            <Option type="Map">
              <Option name="name" type="QString" value=""/>
              <Option name="properties"/>
              <Option name="type" type="QString" value="collection"/>
            </Option>
          </dd_properties>
        </settings>
      </rule>
    </rules>
  </labeling>
  <customproperties>
    <property key="embeddedWidgets/count" value="0"/>
    <property key="variableNames"/>
    <property key="variableValues"/>
  </customproperties>
  <blendMode>0</blendMode>
  <featureBlendMode>0</featureBlendMode>
  <layerOpacity>0.4</layerOpacity>
  <geometryOptions geometryPrecision="0" removeDuplicateNodes="0">
    <activeChecks/>
    <checkConfiguration/>
  </geometryOptions>
  <fieldConfiguration>
    <field name="id">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="rioolput">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="threedi_id">
      <editWidget type="Range">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="vorm">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="breedte">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="lengte">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="type_knooppunt">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="bodemhoogte">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="maaiveldhoogte">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
  </fieldConfiguration>
  <aliases>
    <alias name="" field="id" index="0"/>
    <alias name="" field="rioolput" index="1"/>
    <alias name="" field="threedi_id" index="2"/>
    <alias name="" field="vorm" index="3"/>
    <alias name="" field="breedte" index="4"/>
    <alias name="" field="lengte" index="5"/>
    <alias name="" field="type_knooppunt" index="6"/>
    <alias name="" field="bodemhoogte" index="7"/>
    <alias name="" field="maaiveldhoogte" index="8"/>
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
    <constraint field="id" constraints="3" exp_strength="0" unique_strength="1" notnull_strength="1"/>
    <constraint field="rioolput" constraints="0" exp_strength="0" unique_strength="0" notnull_strength="0"/>
    <constraint field="threedi_id" constraints="0" exp_strength="0" unique_strength="0" notnull_strength="0"/>
    <constraint field="vorm" constraints="0" exp_strength="0" unique_strength="0" notnull_strength="0"/>
    <constraint field="breedte" constraints="0" exp_strength="0" unique_strength="0" notnull_strength="0"/>
    <constraint field="lengte" constraints="0" exp_strength="0" unique_strength="0" notnull_strength="0"/>
    <constraint field="type_knooppunt" constraints="0" exp_strength="0" unique_strength="0" notnull_strength="0"/>
    <constraint field="bodemhoogte" constraints="0" exp_strength="0" unique_strength="0" notnull_strength="0"/>
    <constraint field="maaiveldhoogte" constraints="0" exp_strength="0" unique_strength="0" notnull_strength="0"/>
  </constraints>
  <constraintExpressions>
    <constraint exp="" field="id" desc=""/>
    <constraint exp="" field="rioolput" desc=""/>
    <constraint exp="" field="threedi_id" desc=""/>
    <constraint exp="" field="vorm" desc=""/>
    <constraint exp="" field="breedte" desc=""/>
    <constraint exp="" field="lengte" desc=""/>
    <constraint exp="" field="type_knooppunt" desc=""/>
    <constraint exp="" field="bodemhoogte" desc=""/>
    <constraint exp="" field="maaiveldhoogte" desc=""/>
  </constraintExpressions>
  <expressionfields/>
  <attributeactions>
    <defaultAction key="Canvas" value="{00000000-0000-0000-0000-000000000000}"/>
  </attributeactions>
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
  <editforminitcode><![CDATA[# -*- coding: utf-8 -*-
"""
Formulieren van QGIS kunnen een functie voor Python hebben die wordt aangeroepen wanneer het formulier wordt geopend.

Gebruik deze functie om extra logica aan uw formulieren toe te voegen.

Voer de naam van de functie in in het veld "Python Init function".

Een voorbeeld volgt hieronder:
"""
from qgis.PyQt.QtWidgets import QWidget

def my_form_open(dialog, layer, feature):
	geom = feature.geometry()
	control = dialog.findChild(QWidget, "MyLineEdit")
]]></editforminitcode>
  <featformsuppress>0</featformsuppress>
  <editorlayout>generatedlayout</editorlayout>
  <editable/>
  <labelOnTop/>
  <widgets/>
  <previewExpression></previewExpression>
  <mapTip></mapTip>
  <layerGeometryType>0</layerGeometryType>
</qgis>
