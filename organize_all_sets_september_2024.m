clc
clear;
close;

%%
x = dir;
folderList = 0;
x = string({x.name});
folders_to_check = x(3:end); 
folders_to_check = folders_to_check(~startsWith(folders_to_check, '.'));
main_folder = pwd; 

%%
for abc=1:length(folders_to_check)
    if ispc
        working_folder = strcat(main_folder,  "\", folders_to_check(abc), "\");
    elseif ismac || isunix
        working_folder = strcat(main_folder,  "/", folders_to_check(abc), "/");
    
    end
    cd(working_folder);
    disp(string(working_folder));
    try
        main_core_organize_all_sets_september_2024;  
    catch
        disp(strcat("folder empty: ", folders_to_check(abc)));
    end
    % close all;
    % organized_script_july_2024;
end
cd(main_folder);
close all;