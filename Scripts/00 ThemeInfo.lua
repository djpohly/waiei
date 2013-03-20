-- theme identification:
themeInfo = {
	ProductCode = "waiei-1300",
	Name = "waiei",
	Version = 1.300,
	Date = "20130310",
	Internal = "rel 00000001-1300",
	Revision = 1300,
	Type = "",
}

function GetThemeVersionInformation(prm)
	return themeInfo[prm];
end;