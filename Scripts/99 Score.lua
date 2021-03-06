-- [ja] CustomScore_SM5b1(プレイヤー,モード,steps,現在のステップ数,最後の判定) 
function CustomScore_SM5b1(params,scoremode,steps,cur)
	local pn=params.Player;
	local pss=STATSMAN:GetCurStageStats():GetPlayerStageStats(pn);
	if (GAMESTATE:GetPlayerState(pn):GetPlayerController()~='PlayerController_Autoplay') then
		local ret=0;
		local rv=steps:GetRadarValues(pn);
		local maxsteps=math.max(rv:GetValue('RadarCategory_TapsAndHolds')
			+rv:GetValue('RadarCategory_Holds')+rv:GetValue('RadarCategory_Rolls'),1);
		if scoremode=="SuperNOVA2" then
			local w1=pss:GetTapNoteScores('TapNoteScore_W1');
			local w2=pss:GetTapNoteScores('TapNoteScore_W2');
			local w3=pss:GetTapNoteScores('TapNoteScore_W3');
			local hd=pss:GetHoldNoteScores('HoldNoteScore_Held');
			local minus=0;	-- [ja] b1では強制でデフォルトスコア計算の値が加算されるのでマイナスする 
			if params.HoldNoteScore=='HoldNoteScore_Held' then
				hd=hd+1;
				minus=5;
			elseif params.TapNoteScore=='TapNoteScore_W1' then
				w1=w1+1;
				minus=5;
			elseif params.TapNoteScore=='TapNoteScore_W2' then
				w2=w2+1;
				minus=4;
			elseif params.TapNoteScore=='TapNoteScore_W3' then
				w3=w3+1;
				minus=3;
			elseif params.TapNoteScore=='TapNoteScore_W4' then
				minus=2;
			elseif params.TapNoteScore=='TapNoteScore_W5' then
				minus=1;
			end;
			ret=(math.round((w1 + w2 + w3/2 + hd) *100000/maxsteps-(w2 + w3))*10)-minus;
			pss:SetScore(ret);
		elseif scoremode=="3.9" or scoremode=="Hybrid" then
			local maxscore;
			if scoremode=="3.9" then
				maxscore=math.max(math.min(steps:GetMeter(),10),1)*10000000;
			else
				maxscore=100000000;
			end;
			if _SONG():IsMarathon() then
				maxscore=maxscore*3;
			elseif _SONG():IsLong() then
				maxscore=maxscore*2;
			end;
			local resolution=(((maxsteps+1)*maxsteps)/2)
			local onescore=math.floor(maxscore/resolution);
			local lastscore=((cur==maxsteps) and maxscore-(onescore*resolution) or 0);
			local curscore=pss:GetScore();
			local addscore=0;
			local minus=0;	-- [ja] b1では強制でデフォルトスコア計算の値が加算されるのでマイナスする 
			if params.HoldNoteScore=='HoldNoteScore_Held' then
				addscore=onescore*cur;
				minus=5;
			elseif params.TapNoteScore=='TapNoteScore_W1' then
				addscore=onescore*cur+lastscore;
				minus=5;
			elseif params.TapNoteScore=='TapNoteScore_W2' then
				addscore=math.floor(onescore*cur*0.9)+lastscore;
				minus=4;
			elseif params.TapNoteScore=='TapNoteScore_W3' then
				addscore=math.floor(onescore*cur*0.5)+lastscore;
				minus=3;
			elseif params.TapNoteScore=='TapNoteScore_W4' then
				minus=2;
			elseif params.TapNoteScore=='TapNoteScore_W5' then
				minus=1;
			end;
			ret=pss:GetScore()+addscore-minus;
			pss:SetScore(ret);
		else
			-- [ja] カスタムスコアを使用しない 
		end;
	else
		pss:SetScore(0);
	end;
	return;
end;

--[ja] SM5本体のバージョンを取得してスコア計算方法を取得する 
function GetCustomScoreMode()
	local customscore="";
	if string.find(ProductVersion(),"v5.0 alpha 1",0,true)
		or string.find(ProductVersion(),"v5.0 preview",0,true) then
		customscore="old";
	elseif string.find(ProductVersion(),"v5.0 beta 1",0,true) then
		customscore="5b1";
	else
		customscore="non";
	end;
	return customscore;
end;

function ItgScoreString(pts, max)
	if max <= 0 then
		return "0.00%"
	end;
	local pct = pts/max * 100
	local display = string.format("%.2f", pct)

	if display == "100.00" then
		-- Don't allow a round-up to 100%
		if pts < max then
			return "99.99%"
		else
			return "100%"
		end
	end
	return display .. "%"
end

function ItgScore(pss)
	local tStats = {
		W1			= pss:GetTapNoteScores('TapNoteScore_W1');
		W2			= pss:GetTapNoteScores('TapNoteScore_W2');
		W3			= pss:GetTapNoteScores('TapNoteScore_W3');
		W4			= pss:GetTapNoteScores('TapNoteScore_W4');
		W5			= pss:GetTapNoteScores('TapNoteScore_W5');
		Miss		= pss:GetTapNoteScores('TapNoteScore_Miss');
		HitMine		= pss:GetTapNoteScores('TapNoteScore_HitMine');
		AvoidMine	= pss:GetTapNoteScores('TapNoteScore_AvoidMine');
		Held		= pss:GetHoldNoteScores('HoldNoteScore_Held');
		LetGo		= pss:GetHoldNoteScores('HoldNoteScore_LetGo');
		Total		= 1;
		HoldsAndRolls = 0;
		Seconds		= pss:GetCurrentLife();
	};

	local itg = ( tStats["W1"]*7 + tStats["W2"]*6 + tStats["W3"]*5 + tStats["W4"]*4 + tStats["W5"]*2 + tStats["Held"]*7 );

	-- itg_max is problematic if the players hold down START to exit prematurely...
	local itg_max = ( tStats["W1"] + tStats["W2"] + tStats["W3"] + tStats["W4"] + tStats["W5"] + tStats["Miss"] + tStats["Held"] + tStats["LetGo"] )*7;

	return {itg, itg_max}
end
