<!DOCTYPE qgis PUBLIC 'http://mrcc.com/qgis.dtd' 'SYSTEM'>
<qgis hasScaleBasedVisibilityFlag="0" simplifyLocal="1" readOnly="0" simplifyDrawingHints="1" minScale="0" simplifyAlgorithm="0" version="3.8.0-Zanzibar" maxScale="0" labelsEnabled="1" styleCategories="AllStyleCategories" simplifyMaxScale="1" simplifyDrawingTol="1">
  <flags>
    <Identifiable>1</Identifiable>
    <Removable>1</Removable>
    <Searchable>1</Searchable>
  </flags>
  <renderer-v2 symbollevels="0" type="RuleRenderer" enableorderby="0" forceraster="0">
    <rules key="{e4438d9a-7f72-4911-a6be-6292c7ad2e68}">
      <rule label="inspectieput" key="{74bfc7d4-f299-4d26-9fee-bb4f9b43006b}" scalemaxdenom="5000" scalemindenom="1" symbol="0" filter="&quot;type_knooppunt&quot; = 'inspectieput'"/>
      <rule label="pomp" key="{c2277bf1-0a02-4dfe-b668-1745bc72b629}" scalemaxdenom="5000" scalemindenom="1" symbol="1" filter="&quot;type_knooppunt&quot; = 'pomp'"/>
      <rule label="uitlaat" key="{28be3702-c2ce-46e3-8bf4-798fd27398cc}" scalemaxdenom="5000" scalemindenom="1" symbol="2" filter="&quot;type_knooppunt&quot; = 'uitlaat'"/>
    </rules>
    <symbols>
      <symbol clip_to_extent="1" type="marker" name="0" force_rhr="0" alpha="1">
        <layer enabled="1" class="SimpleMarker" locked="0" pass="0">
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
          <prop v="1" k="size"/>
          <prop v="3x:0,0,0,0,0,0" k="size_map_unit_scale"/>
          <prop v="MM" k="size_unit"/>
          <prop v="1" k="vertical_anchor_point"/>
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
      <symbol clip_to_extent="1" type="marker" name="1" force_rhr="0" alpha="1">
        <layer enabled="1" class="SimpleMarker" locked="0" pass="0">
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
              <Option type="QString" name="name" value=""/>
              <Option name="properties"/>
              <Option type="QString" name="type" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol clip_to_extent="1" type="marker" name="2" force_rhr="0" alpha="1">
        <layer enabled="1" class="SimpleMarker" locked="0" pass="0">
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
      <rule key="{f3c15924-385f-43f7-a35a-95e4d5cd7797}" scalemaxdenom="1000" scalemindenom="1">
        <settings>
          <text-style fontUnderline="0" blendMode="0" fontSizeUnit="Point" textOpacity="1" fontLetterSpacing="0" fontStrikeout="0" fontSizeMapUnitScale="3x:0,0,0,0,0,0" fontWeight="50" previewBkgrdColor="#ffffff" multilineHeight="1" fontSize="10" isExpression="0" fontWordSpacing="0" fontFamily="MS Shell Dlg 2" fieldName="rioolput" fontCapitals="0" namedStyle="Regular" fontItalic="0" textColor="0,0,0,255" useSubstitutions="0">
            <text-buffer bufferColor="255,255,255,255" bufferNoFill="1" bufferOpacity="1" bufferSize="1" bufferJoinStyle="128" bufferBlendMode="0" bufferDraw="0" bufferSizeUnits="MM" bufferSizeMapUnitScale="3x:0,0,0,0,0,0"/>
            <background shapeBorderWidthMapUnitScale="3x:0,0,0,0,0,0" shapeRotationType="0" shapeFillColor="255,255,255,255" shapeOffsetY="0" shapeOffsetX="0" shapeDraw="0" shapeSizeY="0" shapeJoinStyle="64" shapeSVGFile="" shapeType="0" shapeBlendMode="0" shapeSizeType="0" shapeOffsetUnit="MM" shapeBorderWidthUnit="MM" shapeSizeUnit="MM" shapeRadiiX="0" shapeRadiiUnit="MM" shapeRotation="0" shapeRadiiMapUnitScale="3x:0,0,0,0,0,0" shapeSizeX="0" shapeBorderColor="128,128,128,255" shapeRadiiY="0" shapeBorderWidth="0" shapeOpacity="1" shapeSizeMapUnitScale="3x:0,0,0,0,0,0" shapeOffsetMapUnitScale="3x:0,0,0,0,0,0"/>
            <shadow shadowDraw="0" shadowScale="100" shadowOffsetGlobal="1" shadowRadiusUnit="MM" shadowRadiusMapUnitScale="3x:0,0,0,0,0,0" shadowOffsetAngle="135" shadowUnder="0" shadowBlendMode="6" shadowRadiusAlphaOnly="0" shadowRadius="1.5" shadowOpacity="0.7" shadowOffsetDist="1" shadowOffsetUnit="MM" shadowColor="0,0,0,255" shadowOffsetMapUnitScale="3x:0,0,0,0,0,0"/>
            <substitutions/>
          </text-style>
          <text-format wrapChar="" leftDirectionSymbol="&lt;" plussign="0" reverseDirectionSymbol="0" addDirectionSymbol="0" useMaxLineLengthForAutoWrap="1" rightDirectionSymbol=">" decimals="3" autoWrapLength="0" multilineAlign="3" placeDirectionSymbol="0" formatNumbers="0"/>
          <placement maxCurvedCharAngleOut="-25" priority="5" distMapUnitScale="3x:0,0,0,0,0,0" centroidWhole="0" repeatDistanceUnits="MM" placementFlags="10" geometryGeneratorEnabled="0" offsetUnits="Point" distUnits="MM" dist="0" predefinedPositionOrder="TR,TL,BR,BL,R,L,TSR,BSR" preserveRotation="1" yOffset="-8" fitInPolygonOnly="0" repeatDistance="0" quadOffset="2" xOffset="22" maxCurvedCharAngleIn="25" placement="1" centroidInside="0" geometryGeneratorType="PointGeometry" offsetType="0" geometryGenerator="" labelOffsetMapUnitScale="3x:0,0,0,0,0,0" rotationAngle="0" repeatDistanceMapUnitScale="3x:0,0,0,0,0,0"/>
          <rendering displayAll="1" obstacle="1" zIndex="0" upsidedownLabels="0" obstacleFactor="1" mergeLines="0" fontLimitPixelSize="0" fontMaxPixelSize="10000" obstacleType="0" scaleVisibility="1" scaleMax="2000" scaleMin="1" minFeatureSize="0" labelPerPart="0" fontMinPixelSize="3" limitNumLabels="0" maxNumLabels="2000" drawLabels="1"/>
          <dd_properties>
            <Option type="Map">
              <Option type="QString" name="name" value=""/>
              <Option name="properties"/>
              <Option type="QString" name="type" value="collection"/>
            </Option>
          </dd_properties>
        </settings>
      </rule>
      <rule key="{b8014d9d-ebbb-4276-8bed-e64d4a543ff8}" scalemaxdenom="2000" scalemindenom="1000">
        <settings>
          <text-style fontUnderline="0" blendMode="0" fontSizeUnit="Point" textOpacity="1" fontLetterSpacing="0" fontStrikeout="0" fontSizeMapUnitScale="3x:0,0,0,0,0,0" fontWeight="50" previewBkgrdColor="#ffffff" multilineHeight="1" fontSize="10" isExpression="0" fontWordSpacing="0" fontFamily="MS Shell Dlg 2" fieldName="rioolput" fontCapitals="0" namedStyle="Regular" fontItalic="0" textColor="0,0,0,255" useSubstitutions="0">
            <text-buffer bufferColor="255,255,255,255" bufferNoFill="1" bufferOpacity="1" bufferSize="1" bufferJoinStyle="128" bufferBlendMode="0" bufferDraw="0" bufferSizeUnits="MM" bufferSizeMapUnitScale="3x:0,0,0,0,0,0"/>
            <background shapeBorderWidthMapUnitScale="3x:0,0,0,0,0,0" shapeRotationType="0" shapeFillColor="255,255,255,255" shapeOffsetY="0" shapeOffsetX="0" shapeDraw="0" shapeSizeY="0" shapeJoinStyle="64" shapeSVGFile="" shapeType="0" shapeBlendMode="0" shapeSizeType="0" shapeOffsetUnit="MM" shapeBorderWidthUnit="MM" shapeSizeUnit="MM" shapeRadiiX="0" shapeRadiiUnit="MM" shapeRotation="0" shapeRadiiMapUnitScale="3x:0,0,0,0,0,0" shapeSizeX="0" shapeBorderColor="128,128,128,255" shapeRadiiY="0" shapeBorderWidth="0" shapeOpacity="1" shapeSizeMapUnitScale="3x:0,0,0,0,0,0" shapeOffsetMapUnitScale="3x:0,0,0,0,0,0"/>
            <shadow shadowDraw="0" shadowScale="100" shadowOffsetGlobal="1" shadowRadiusUnit="MM" shadowRadiusMapUnitScale="3x:0,0,0,0,0,0" shadowOffsetAngle="135" shadowUnder="0" shadowBlendMode="6" shadowRadiusAlphaOnly="0" shadowRadius="1.5" shadowOpacity="0.7" shadowOffsetDist="1" shadowOffsetUnit="MM" shadowColor="0,0,0,255" shadowOffsetMapUnitScale="3x:0,0,0,0,0,0"/>
            <substitutions/>
          </text-style>
          <text-format wrapChar="" leftDirectionSymbol="&lt;" plussign="0" reverseDirectionSymbol="0" addDirectionSymbol="0" useMaxLineLengthForAutoWrap="1" rightDirectionSymbol=">" decimals="3" autoWrapLength="0" multilineAlign="3" placeDirectionSymbol="0" formatNumbers="0"/>
          <placement maxCurvedCharAngleOut="-25" priority="5" distMapUnitScale="3x:0,0,0,0,0,0" centroidWhole="0" repeatDistanceUnits="MM" placementFlags="10" geometryGeneratorEnabled="0" offsetUnits="Point" distUnits="MM" dist="0" predefinedPositionOrder="TR,TL,BR,BL,R,L,TSR,BSR" preserveRotation="1" yOffset="-2" fitInPolygonOnly="0" repeatDistance="0" quadOffset="2" xOffset="4" maxCurvedCharAngleIn="25" placement="1" centroidInside="0" geometryGeneratorType="PointGeometry" offsetType="0" geometryGenerator="" labelOffsetMapUnitScale="3x:0,0,0,0,0,0" rotationAngle="0" repeatDistanceMapUnitScale="3x:0,0,0,0,0,0"/>
          <rendering displayAll="1" obstacle="1" zIndex="0" upsidedownLabels="0" obstacleFactor="1" mergeLines="0" fontLimitPixelSize="0" fontMaxPixelSize="10000" obstacleType="0" scaleVisibility="1" scaleMax="2000" scaleMin="1" minFeatureSize="0" labelPerPart="0" fontMinPixelSize="3" limitNumLabels="0" maxNumLabels="2000" drawLabels="1"/>
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
  <customproperties>
    <property key="embeddedWidgets/count" value="0"/>
    <property key="variableNames"/>
    <property key="variableValues"/>
  </customproperties>
  <blendMode>0</blendMode>
  <featureBlendMode>0</featureBlendMode>
  <layerOpacity>0.4</layerOpacity>
  <geometryOptions removeDuplicateNodes="0" geometryPrecision="0">
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
    <constraint field="id" notnull_strength="1" constraints="3" exp_strength="0" unique_strength="1"/>
    <constraint field="rioolput" notnull_strength="0" constraints="0" exp_strength="0" unique_strength="0"/>
    <constraint field="threedi_id" notnull_strength="0" constraints="0" exp_strength="0" unique_strength="0"/>
    <constraint field="vorm" notnull_strength="0" constraints="0" exp_strength="0" unique_strength="0"/>
    <constraint field="breedte" notnull_strength="0" constraints="0" exp_strength="0" unique_strength="0"/>
    <constraint field="lengte" notnull_strength="0" constraints="0" exp_strength="0" unique_strength="0"/>
    <constraint field="type_knooppunt" notnull_strength="0" constraints="0" exp_strength="0" unique_strength="0"/>
    <constraint field="bodemhoogte" notnull_strength="0" constraints="0" exp_strength="0" unique_strength="0"/>
    <constraint field="maaiveldhoogte" notnull_strength="0" constraints="0" exp_strength="0" unique_strength="0"/>
  </constraints>
  <constraintExpressions>
    <constraint field="id" exp="" desc=""/>
    <constraint field="rioolput" exp="" desc=""/>
    <constraint field="threedi_id" exp="" desc=""/>
    <constraint field="vorm" exp="" desc=""/>
    <constraint field="breedte" exp="" desc=""/>
    <constraint field="lengte" exp="" desc=""/>
    <constraint field="type_knooppunt" exp="" desc=""/>
    <constraint field="bodemhoogte" exp="" desc=""/>
    <constraint field="maaiveldhoogte" exp="" desc=""/>
  </constraintExpressions>
  <expressionfields/>
  <attributeactions>
    <defaultAction key="Canvas" value="{00000000-0000-0000-0000-000000000000}"/>
  </attributeactions>
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
