function [CorretClassification, MissClassification, accuracy] = avaliacaoRedeSVM(classes, saidasRede, saidasDesejada)

	MissClassification = zeros(1,classes,'double');
	CorretClassification = zeros(1,classes,'double');
	
	[exemplos] = numel(saidasRede);
    
	for index = 1 : exemplos;
		%disp('===========');
        if saidasRede(index) ~= saidasDesejada(index)
            MissClassification(saidasDesejada(index)) = MissClassification(saidasDesejada(index))+1;
		else
			CorretClassification(saidasDesejada(index)) = CorretClassification(saidasDesejada(index))+1;
        end
        %index
	    %saidasRede(index) 
        %saidasDesejada(index)
        %MissClassification
        %CorretClassification
    end
	
    accuracy = zeros(1,classes,'double');
    for i=1:classes
        accuracy(i) = 1-(MissClassification(i)/(MissClassification(i)+CorretClassification(i)));
    end
	%disp('***********');
    %saidasRede
    %saidasDesejada
    %accuracy
    %MissClassification
    %CorretClassification