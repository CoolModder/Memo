local c = app.fgColor;
local FileName;
local FileContents;
---------------------------
local dlg = Dialog("Memo")
local txtdlg = Dialog()
dlg   :separator{ text="File Info" }
	  :file{ 
		id="File",
		label="File:",
		open=true,
		filetypes={ "txt","xml", "json"},
		onchange=function()
			FileName = dlg.data.File -- Gets file name
		end }

	   :button{ text="Open File",
            onclick=function()
				if (FileName and FileName ~= "") then
					file, err = io.open(FileName, "r")
					if (file) then
		
						local linecount = 1
						FileContents = {}
						txtdlg = Dialog()
						for line in file:lines() do
							if (linecount < 16) then
								txtdlg :label{id= tostring(linecount), label = "", text = line:gsub("\t", "    ")}
							end
							linecount = linecount + 1
							table.insert(FileContents, line)
						end
						txtdlg:slider{ 
							id= "LineNum", 
							label="Line", 
							min = 1, 
							max = math.clamp(linecount-15, 1, 1000), 
							value = 1, 	
							onchange=function()
								local LineNumber = txtdlg.data.LineNum 
								for i = 1, 15 do
									txtdlg :modify{ id = i, text = FileContents[LineNumber + i - 1]:gsub("\t", "    ")}
								end
							end }
						txtdlg:modify{ title = "Memo - " .. FileName}
						txtdlg:show{wait=false}
					else
					    app.alert("Couldn't open file: " .. err) 
					end
				end
				
				
			end }
      :show{wait=false}
	  
function math.clamp(x, min, max)
    if x < min then return min end
    if x > max then return max end
    return x
end
	  

---------------------------------------
