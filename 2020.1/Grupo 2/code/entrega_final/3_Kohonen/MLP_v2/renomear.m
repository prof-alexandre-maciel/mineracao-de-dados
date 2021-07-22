	clc;
	clear ; close all

    %pasta = 'iteracao';
    %pasta = 'confusao';
    pasta = 'boxplot';
    MyFolderInfo = dir(pasta);

    index = 1;
    while(exist(strcat(pasta,'/',MyFolderInfo(index).name), 'file') ~= 2)
        index = index + 1;
    end
    numel(MyFolderInfo)

    for i=index:numel(MyFolderInfo)
        ori = MyFolderInfo(i).name;
        chr = strrep(ori,'numEscondidos','numEscondidos_');
        %chr = strrep(ori,'fold_','peso_');
        %chr = strrep(chr,'fold','peso');
        
	
        ori 
        chr
        if (strcmp(ori,chr)==0)
            movefile(strcat(pasta,'/',ori), strcat(pasta,'/',chr));
        end
    end
	