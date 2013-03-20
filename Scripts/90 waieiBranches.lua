
Branch_Theme = {
	Welcomewaiei = function()
		if GetUserPref_Theme("waieiThemeVersion") ~= nil then
			if GetUserPref_Theme("waieiThemeVersion") ~= (""..GetThemeVersionInformation("Version")) then
				return "ScreenWelcomewaiei";
			else
				return Branch.AfterInit();
			end;
		else
			SetUserPref_Theme("waieiThemeVersion",GetThemeVersionInformation("Version"));
			return "ScreenWelcomewaiei";
		end;
	end,
	AfterProfileSave = function()
		if GAMESTATE:IsEventMode() then
			return SelectMusicOrCourse()
		elseif STATSMAN:GetCurStageStats():AllFailed() or GAMESTATE:IsCourseMode() then
			if GAMESTATE:GetCurrentStageIndex()<2 then
				return "ScreenGameOver"
			else
				return "ScreenEvaluationSummary"
			end;
		elseif GAMESTATE:GetSmallestNumStagesLeftForAnyHumanPlayer() == 0 then
			return "ScreenEvaluationSummary"
		else
			return SelectMusicOrCourse()
		end
	end,
	AfterSummary = function()
		return "ScreenProfileSaveSummary"
	end,
};
