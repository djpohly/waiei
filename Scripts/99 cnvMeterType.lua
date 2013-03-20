--[ja] 難易度変換 
local ddr2x={
	1,2.5,4,5.2,5.8,6.4,8.6,11.4,13,15.5,16.2,17.8
};
local tapsp2x={
	 0.5, 0.6, 0.7, 0.8, 0.9, 1.0, 1.2, 1.5, 1.7, 2.0,
	 2.3, 2.6, 3.0, 3.3, 3.6, 4.0, 4.3, 4.6, 5.0, 5.2,
	 5.5, 5.7, 6.0, 6.2, 6.5, 6.7, 7.0, 7.2, 7.4, 7.6,
	 7.8, 8.0, 8.3, 8.6, 9.0, 9.2, 9.4, 9.6, 9.8,10.0,
	10.2,10.5,10.7,11.0,11.3,11.6,12.0,12.0,12.2,12.4,
	12.6,12.8,13.0,13.0,13.3,13.5,13.7,14.0,14.2,14.4,
	14.5,14.5,14.6,14.8,15.0,15.2,15.4,15.6,15.8,16.0,
	16.2,16.4,16.6,16.8,17.0,17.3,17.6,17.8,17.8,17.8,
	17.8,17.9,17.9,17.9,18.0,18.0,18.0,18.1,18.1,18.1,
	18.2,18.2,18.2,18.2,18.2,18.2,18.5,18.7,19.0,19.5
};
-- [ja] 100段階用（テスト実装） 
local ddr2lv100={
	1,2.5,4,5.2,5.8,6.4,8.6,11.4,13,15.5,16.2,17.8,19,20
};
local tapsp2lv100={
	 0.5,0.55, 0.6,0.65, 0.7,0.75, 0.8,0.85, 0.9,0.95,
	 1.0, 1.2, 1.4, 1.6, 1.7, 1.8, 1.9, 2.0, 2.2, 2.3,
	 2.5, 2.6, 3.0, 3.3, 3.6, 4.0, 4.3, 4.6, 5.0, 5.2,
	 5.5, 5.7, 6.0, 6.2, 6.5, 6.7, 7.0, 7.2, 7.4, 7.6,
	 7.8, 8.0, 8.3, 8.6, 9.0, 9.2, 9.4, 9.6, 9.8,10.0,
	10.2,10.5,10.7,11.0,11.3,11.6,12.0,12.0,12.2,12.4,
	12.6,12.8,13.0,13.0,13.3,13.5,13.7,14.0,14.2,14.4,
	14.5,14.5,14.6,14.8,15.0,15.2,15.4,15.6,15.8,16.0,
	16.2,16.4,16.6,16.8,17.0,17.2,17.4,17.6,17.8,18.0,
	18.2,18.4,18.6,18.8,19.0,19.2,19.4,19.6,19.8,20.0,
	20.2,20.4,20.6,20.8,21.0,21.2,21.4,21.6,21.8,22.0,
	22.2,22.4,22.6,22.8,23.0,23.2,23.4,23.6,23.8,24.0,
	24.2,24.4,24.6,24.8,25.0,25.2,25.4,25.6,25.8,26.0,
	26.2,26.4,26.6,26.8,27.0,27.2,27.4,27.6,27.8,28.0,
	28.2,28.4,28.6,28.8,29.0,29.2,29.4,29.6,29.8,30.0,
	30.2,30.4,30.6,30.8,31.0,31.2,31.4,31.6,31.8,32.0,
	32.2,32.4,32.6,32.8,33.0,33.2,33.4,33.6,33.8,34.0,
	34.2,34.4,34.6,34.8,35.0,35.2,35.4,35.6,35.8,36.0,
	36.4,36.8,37.2,37.6,38.0,38.4,38.8,39.2,39.6,40.0,
	40.5,41.0,41.5,42.0,42.5,43.0,43.5,44.0,44.5,45.0,
	45.5,46.0,46.5,47.0,47.5,48.0,48.5,49.0,49.5,50.0
};
local x2ddr={
	 0.8, 1.0, 2.0, 3.0, 4.0, 5.0, 5.5, 6.0, 7.0, 7.5,
	 8.0, 8.5, 9.0, 9.5,10.0,10.2,10.5,11.0,11.5
};
local tapsp2ddr={
	 0.3, 0.5, 0.6, 0.8, 1.0, 1.2, 1.4, 1.5, 1.6, 1.7,
	 1.9, 2.0, 2.3, 2.6, 3.0, 3.3, 3.6, 4.0, 4.2, 4.5,
	 4.7, 5.0, 5.3, 5.6, 6.0, 6.1, 6.3, 6.5, 6.6, 6.7,
	 6.9, 7.0, 7.2, 7.5, 7.7, 8.0, 8.2, 8.4, 8.6, 8.8,
	 8.9, 9.0, 9.1, 9.1, 9.2, 9.2, 9.3, 9.4, 9.5, 9.7,
	 9.9,10.0,10.1,10.2,10.3,10.4,10.5,10.5,10.6,10.7,
	10.8,10.9,11.0,11.1,11.3,11.5,11.6,11.8,11.9,12.0
};
-- [ja] MAX値が10用 
local x2ddr10={
	 0.8, 1.0, 2.0, 3.0, 4.0, 5.0, 5.5, 6.0, 7.0, 7.5,
	 8.0, 8.5, 9.0, 9.5,10.0,10.0,10.0,10.0,10.0
};
local tapsp2ddr10={
	 0.3, 0.5, 0.6, 0.8, 1.0, 1.2, 1.4, 1.5, 1.6, 1.7,
	 1.9, 2.0, 2.3, 2.6, 3.0, 3.3, 3.6, 4.0, 4.2, 4.5,
	 4.7, 5.0, 5.3, 5.6, 6.0, 6.1, 6.3, 6.5, 6.6, 6.7,
	 6.9, 7.0, 7.2, 7.5, 7.7, 8.0, 8.2, 8.4, 8.6, 8.8,
	 8.9, 9.0, 9.1, 9.1, 9.2, 9.2, 9.3, 9.4, 9.5, 9.7,
	 9.9,10.0,10.1,10.2,10.3,10.4,10.5,10.5,10.6,10.7,
	10.8,10.9
};

function GetConvertDifficulty(song,style,dif,_metertype,mt)
	local metertype=string.lower(_metertype);
	local songlen=math.max(song:GetLastSecond(),1);
	local step=song:GetOneSteps(style,dif);
	local bpms=step:GetTimingData():GetActualBPM();
	local vol=step:GetRadarValues(GetSidePlayer(PLAYER_1)):GetValue('RadarCategory_Voltage');
	local str=step:GetRadarValues(GetSidePlayer(PLAYER_1)):GetValue('RadarCategory_Stream');
	local r_vol=vol-0.5;
	local r_str=str-0.5;
	local tapspoint=step:GetRadarValues(GetSidePlayer(PLAYER_1)):GetValue('RadarCategory_TapsAndHolds');
	tapspoint=step:GetRadarValues(GetSidePlayer(PLAYER_1)):GetValue('RadarCategory_Jumps')/1.05+tapspoint;
	if mt=="LV100" or mt=="LV20" then
		tapspoint=((r_str>=0) and r_str*66 or r_str*50)+tapspoint;
		tapspoint=((r_vol>=0) and r_vol*80 or r_vol*50)+tapspoint;
	end;
	tapspoint=math.max(tapspoint-666,0)*1.05+tapspoint
	tapspoint=step:GetRadarValues(GetSidePlayer(PLAYER_1)):GetValue('RadarCategory_Mines')/8+tapspoint;
	tapspoint=step:GetRadarValues(GetSidePlayer(PLAYER_1)):GetValue('RadarCategory_Holds')/8+tapspoint;
	tapspoint=step:GetRadarValues(GetSidePlayer(PLAYER_1)):GetValue('RadarCategory_Rolls')+tapspoint;
	tapspoint=step:GetRadarValues(GetSidePlayer(PLAYER_1)):GetValue('RadarCategory_Chaos')*10+tapspoint;
	tapspoint=songlen-80+tapspoint;
	tapspoint=math.max(130-bpms[1],0)+tapspoint;
	tapspoint=math.max(math.min(bpms[2],400)-160,0)/5+tapspoint;
	tapspoint=math.round(tapspoint*10/songlen);	--[ja] 難易度を決める基準になる数値（10秒あたりの譜面数） 
	local meter=step:GetMeter();
	if mt then
		if mt=="DDR" and (metertype~="ddr" and metertype~="") then
			tapspoint=math.max(tapspoint+1,1);
			tapspoint=math.min(tapspoint,#tapsp2ddr);
			meter=math.min(meter,#x2ddr);
			meter=x2ddr[math.max(meter,1)];
			meter=math.round((meter+tapsp2ddr[tapspoint])/2);
		elseif mt=="DDR MAX10" and (metertype~="ddr" and metertype~="") then
			tapspoint=math.max(tapspoint+1,1);
			tapspoint=math.min(tapspoint,#tapsp2ddr10);
			meter=math.min(meter,#x2ddr10);
			meter=x2ddr10[math.max(meter,1)];
			meter=math.round((meter+tapsp2ddr10[tapspoint])/2);
		elseif mt=="DDR X" and metertype~="ddr x" then
			if tapspoint>80 then
				meter=math.min(meter+2,#ddr2x);
			else
				meter=math.min(math.min(meter,11),#ddr2x);
			end;
			tapspoint=math.max(tapspoint+1,1);
			tapspoint=math.min(tapspoint,#tapsp2x);
			meter=ddr2x[math.max(meter,1)];
			meter=math.round((meter+tapsp2x[tapspoint])/2);
		elseif mt=="LV100" or mt=="LV20" then
			tapspoint=tapspoint*1.2;
			if songlen>300 then
				tapspoint=tapspoint*1.14;
			elseif songlen>150 then
				tapspoint=tapspoint*1.09;
			elseif songlen>120 then
				tapspoint=tapspoint*1.05;
			elseif songlen>100 then
				tapspoint=tapspoint*1.02;
			elseif songlen<70 then
				tapspoint=tapspoint*0.95;
			elseif songlen<40 then
				tapspoint=tapspoint*0.9;
			end;
			--if dif=='Difficulty_Challenge' then _SYS(tapspoint) end;
			--[ja] LV100相当 
			if tapspoint>=#tapsp2lv100*1.98 then
				tapspoint=#tapsp2lv100
			else
				--[ja] LV80～99相当 
				if tapspoint>=#tapsp2lv100 then
					local max=#tapsp2lv100*1.98-#tapsp2lv100;
					tapspoint=#tapsp2lv100*0.85+(#tapsp2lv100*0.15*math.sin((math.pi*0.5)*(tapspoint-#tapsp2lv100)/max));
				elseif tapspoint>=#tapsp2lv100*0.5 then
					local max=#tapsp2lv100-#tapsp2lv100*0.5;
					tapspoint=#tapsp2lv100*0.5+(#tapsp2lv100*0.35*math.sin((math.pi*0.5)*(tapspoint-#tapsp2lv100*0.5)/max));
				else
				end;
			end;
			--if dif=='Difficulty_Challenge' then _SYS(tapspoint) end;
			tapspoint=math.round(tapspoint);
			tapspoint=math.max(tapspoint+1,1);
			tapspoint=math.min(tapspoint,#tapsp2lv100);
			-- [ja] 従来の10段階に指譜面も考慮した20段階 
			-- [ja] 難易度40を11に設定 
			if mt=="LV20" then
				if tapsp2lv100[tapspoint]<25 then
					meter=math.round(12*math.sin(tapsp2lv100[tapspoint]
						*math.pi*0.5/25));
				elseif tapsp2lv100[tapspoint]<35 then
					meter=math.round((tapsp2lv100[tapspoint]-25)*3/10+12);
				else
					meter=math.round((tapsp2lv100[tapspoint]-35)*5/15+15);
				end;
				meter=math.max(meter,1);
				meter=math.min(meter,20);
			else
				meter=(tapsp2lv100[tapspoint])*2;
				meter=math.max(meter,1);
				meter=math.min(meter,100);
			end;
		end;
	end;
	return meter;
end;
