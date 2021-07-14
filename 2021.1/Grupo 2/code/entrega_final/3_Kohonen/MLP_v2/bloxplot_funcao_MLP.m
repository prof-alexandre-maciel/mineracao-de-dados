function bloxplot_funcao_MLP(qtd_vetor, number_vetor, pasta, vetortrain_accuracy, vetortest_accuracy, vetorTrainingTime, vetorTestingTime)

    %----------------------------------------------------------------------
    [dy, dx] = size(vetortrain_accuracy);
    for u=1:dy
        [nohiddenlayers, numEscondidos, algoritmo] = kernel2str(qtd_vetor, number_vetor, u);
        
        str = strcat(pasta,'/boxplot/vetortrain_accuracy_nohiddenlayers_', int2str(nohiddenlayers),'_numEscondidos_', int2str(numEscondidos),'_',algoritmo, '.txt');
        vetortrain_accuracy_temp = vetortrain_accuracy(u,:);
        save(str , 'vetortrain_accuracy_temp', '-ASCII');
  
        str = strcat(pasta,'/boxplot/vetortest_accuracy_nohiddenlayers_', int2str(nohiddenlayers),'_numEscondidos_', int2str(numEscondidos),'_',algoritmo, '.txt');
        vetortest_accuracy_temp = vetortest_accuracy(u,:);
        save(str , 'vetortest_accuracy_temp', '-ASCII');
        
        str = strcat(pasta,'/boxplot/vetorTrainingTime_nohiddenlayers_', int2str(nohiddenlayers),'_numEscondidos_', int2str(numEscondidos),'_',algoritmo, '.txt');
        vetorTrainingTime_temp = vetorTrainingTime(u,:);
        save(str , 'vetorTrainingTime_temp', '-ASCII');
        
        str = strcat(pasta,'/boxplot/vetorTestingTime_nohiddenlayers_', int2str(nohiddenlayers),'_numEscondidos_', int2str(numEscondidos),'_',algoritmo, '.txt');
        vetorTestingTime_temp = vetorTestingTime(u,:);
        save(str , 'vetorTestingTime_temp', '-ASCII');
    end
 	%----------------------------------------------------------------------
	
	
%=========================================================================================	
function [nohiddenlayers, numEscondidos, kernel] = kernel2str(qtd_vetor, number_vetor, i)
			u = 1;
			if(i<12)
				u = i;
				nohiddenlayers = qtd_vetor(1); 
				numEscondidos = number_vetor(1);
			elseif(i<23)
				u = i-11;
				nohiddenlayers = qtd_vetor(2); 
				numEscondidos = number_vetor(2);
			elseif(i<34)
				u = i-22;
				nohiddenlayers = qtd_vetor(3); 
				numEscondidos = number_vetor(3);
			else
				u = i-33;
				nohiddenlayers = qtd_vetor(4); 
				numEscondidos = number_vetor(4);
			end
			
			if u==1
                kernel = 'trainb';
            elseif u==2
                kernel = 'traincgb';
			elseif u==3
                kernel = 'traincgf';
            elseif u==4
                kernel = 'traincgp';
            elseif u==5
                kernel = 'traingd';
            elseif u==6
                kernel = 'traingdm';
            elseif u==7
                kernel = 'traingda';
            elseif u==8
                kernel = 'traingdx';
            elseif u==9
                kernel = 'trainoss';
            elseif u==10
                kernel = 'trainrp';
            else
                kernel = 'trainscg';		
            end	