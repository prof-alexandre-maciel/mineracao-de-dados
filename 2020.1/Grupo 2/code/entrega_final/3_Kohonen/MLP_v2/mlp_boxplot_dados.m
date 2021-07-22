%==========================================================================	
function [global_kernel_max, nohiddenlayers_max, numEscondidos_max] =...
		 mlp_boxplot_dados(qtd_vetor, number_vetor, classificador, total)
	
	global_kernel_max = 'trainb';
	nohiddenlayers_max = qtd_vetor(1);
	numEscondidos_max = number_vetor(1);
	result_max = -1.0;
			
	path1 = strcat('MLP_v2/iteracao/resultadoFinal.txt');
	fid = fopen(char(path1),'w');
	
	for q_index=1:numel(qtd_vetor)
		resultado_final(classificador,q_index);
		nohiddenlayers = qtd_vetor(q_index);
		numEscondidos = number_vetor(q_index);
		%------------------------------------------------------------------    
		u = 1;
		[global_kernel_max,result_max,nohiddenlayers_max,numEscondidos_max,...
        a1,b1,c1,d1] =... 
		recupera_vetor(global_kernel_max, result_max, nohiddenlayers_max, numEscondidos_max,...
        classificador, nohiddenlayers, numEscondidos,'trainb');
    
		u = u+1;
		[global_kernel_max,result_max,nohiddenlayers_max,numEscondidos_max,...
        a2,b2,c2,d2] =... 
		recupera_vetor(global_kernel_max, result_max,nohiddenlayers_max,numEscondidos_max,... 
        classificador, nohiddenlayers, numEscondidos,'traincgb');
    
		u = u+1;
		[global_kernel_max,result_max,nohiddenlayers_max,numEscondidos_max,...
        a3,b3,c3,d3] =... 
		recupera_vetor(global_kernel_max, result_max,nohiddenlayers_max,numEscondidos_max,... 
        classificador, nohiddenlayers, numEscondidos,'traincgf');
    
		u = u+1;
		[global_kernel_max,result_max,nohiddenlayers_max,numEscondidos_max,...
        a4,b4,c4,d4] =... 
		recupera_vetor(global_kernel_max, result_max,nohiddenlayers_max,numEscondidos_max,... 
        classificador, nohiddenlayers, numEscondidos,'traincgp');
    
		u = u+1;
		[global_kernel_max,result_max,nohiddenlayers_max,numEscondidos_max,...
        a5,b5,c5,d5] =... 
		recupera_vetor(global_kernel_max, result_max,nohiddenlayers_max,numEscondidos_max,... 
        classificador, nohiddenlayers, numEscondidos,'traingd');
    
		u = u+1;
		[global_kernel_max,result_max,nohiddenlayers_max,numEscondidos_max,...
        a6,b6,c6,d6] =... 
		recupera_vetor(global_kernel_max, result_max,nohiddenlayers_max,numEscondidos_max,...
        classificador, nohiddenlayers, numEscondidos,'traingdm');
    
		u = u+1;
		[global_kernel_max,result_max,nohiddenlayers_max,numEscondidos_max,...
        a7,b7,c7,d7] =... 
		recupera_vetor(global_kernel_max, result_max,nohiddenlayers_max,numEscondidos_max,... 
        classificador, nohiddenlayers, numEscondidos,'traingda');
    
		u = u+1;
		[global_kernel_max,result_max,nohiddenlayers_max,numEscondidos_max,...
        a8,b8,c8,d8] =... 
		recupera_vetor(global_kernel_max, result_max,nohiddenlayers_max,numEscondidos_max,... 
        classificador, nohiddenlayers, numEscondidos,'traingdx');
    
		u = u+1;
		[global_kernel_max,result_max,nohiddenlayers_max,numEscondidos_max,...
        a9,b9,c9,d9] =... 
		recupera_vetor(global_kernel_max, result_max,nohiddenlayers_max,numEscondidos_max,... 
        classificador, nohiddenlayers, numEscondidos,'trainoss');
    
		u = u+1;
		[global_kernel_max,result_max,nohiddenlayers_max,numEscondidos_max,...
        a10,b10,c10,d10] =... 
		recupera_vetor(global_kernel_max, result_max,nohiddenlayers_max,numEscondidos_max,... 
        classificador, nohiddenlayers, numEscondidos,'trainrp');
    
		u = u+1;
		[global_kernel_max,result_max,nohiddenlayers_max,numEscondidos_max,...
        a11,b11,c11,d11] =...
		recupera_vetor(global_kernel_max, result_max,nohiddenlayers_max,numEscondidos_max,...
        classificador, nohiddenlayers, numEscondidos,'trainscg');
		
		a1 = a1*100;
		a2 = a2*100;
		a3 = a3*100;
		a4 = a4*100;
		a5 = a5*100;
		a6 = a6*100;
		a7 = a7*100;
		a8 = a8*100;
		a9 = a9*100;
		a10 = a10*100;
		a11 = a11*100;
		
		b1 = b1*100;
		b2 = b2*100;
		b3 = b3*100;
		b4 = b4*100;
		b5 = b5*100;
		b6 = b6*100;
		b7 = b7*100;
		b8 = b8*100;
		b9 = b9*100;
		b10 = b10*100;
		b11 = b11*100;
		%----------------------------------------------------------------------
		montar_grafico(a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,classificador,'vetortrain_accuracy',nohiddenlayers, numEscondidos);
		montar_grafico(b1,b2,b3,b4,b5,b6,b7,b8,b9,b10,b11,classificador,'vetortest_accuracy',nohiddenlayers, numEscondidos);
		montar_grafico(c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11,classificador,'vetorTrainingTime',nohiddenlayers, numEscondidos);
		montar_grafico(d1,d2,d3,d4,d5,d6,d7,d8,d9,d10,d11,classificador,'vetorTestingTime',nohiddenlayers, numEscondidos);
	end
    %----------------------------------------------------------------------    

%========================================================================== 
function resultado_final(classificador,q)

	path1 = strcat(classificador,'/iteracao/resultadoFinal.txt');
	fid = fopen(char(path1),'a');
    if(q==1)
		fprintf(fid,'==================================================\n');
		fprintf(fid,'Uma única camada esconida contendo 100 neurônios\n');
		fprintf(fid,'===================================================\n');
    elseif(q==2) 
		fprintf(fid,'===================================================\n');
		fprintf(fid,'Duas camadas escondidas contendo 100 neurônios cada\n');
		fprintf(fid,'===================================================\n');
    elseif(q==3) 
		fprintf(fid,'===================================================\n');
		fprintf(fid,'Uma única camada escondida contendo 500 neurônios\n');
		fprintf(fid,'===================================================\n');
    end
	fclose(fid);

%========================================================================== 
function [mediatest_accuracy] = ...
		 resultado_final_kernel(classificador,vetortrain_accuracy,vetortest_accuracy,vetorTrainingTime,vetorTestingTime,kernel)
		
	path1 = strcat(classificador,'/iteracao/resultadoFinal.txt');
	fid = fopen(char(path1),'a');	
    %--------------------------------------------------------------
	patha = strcat('media_train_accuracy_',kernel);
	mediatrain_accuracy = mean(vetortrain_accuracy(:));
	fprintf(fid,'%s %f\n',patha,mediatrain_accuracy);
	patha = strcat('std_train_accuracy_',kernel);
	fprintf(fid,'%s %f\n',patha,std(vetortrain_accuracy(:)));
	
	pathb = strcat('media_test_accuracy_',kernel);
	mediatest_accuracy = mean(vetortest_accuracy(:));
	fprintf(fid,'%s %f\n',pathb,mediatest_accuracy);
	pathb = strcat('std_test_accuracy_',kernel);
	fprintf(fid,'%s %f\n',pathb,std(vetortest_accuracy(:)));
	
	pathc = strcat('media_TrainingTime_',kernel);
	mediaTrainingTime = mean(vetorTrainingTime(:));
	fprintf(fid,'%s %f\n',pathc,mediaTrainingTime);
	pathc = strcat('std_TrainingTime_',kernel);
	fprintf(fid,'%s %f\n',pathc,std(vetorTrainingTime(:)));
	
	pathd = strcat('media_TestingTime_',kernel);
	mediaTestingTime = mean(vetorTestingTime(:));
	fprintf(fid,'%s %f\n',pathd,mediaTestingTime);
	pathd = strcat('std_TestingTime_',kernel);
	fprintf(fid,'%s %f\n',pathd,std(vetorTestingTime(:)));
	fprintf(fid,'------------------------------\n');
	%--------------------------------------------------------------
	fclose(fid);
	
%==========================================================================    
function [global_kernel_max, result_max, nohiddenlayers_max, numEscondidos_max,...
         vector_train_accuracy,vector_test_accuracy,vector_TrainingTime,vector_TestingTime] =...
         recupera_vetor(global_kernel_max, result_max, nohiddenlayers_max, numEscondidos_max,...
          classificador, nohiddenlayers, numEscondidos, kernel)
     
		%----------------------------------------------------------------------
		vector_train_accuracy = [];
		vector_test_accuracy = [];
		vector_TrainingTime = [];
		vector_TestingTime = [];
		count_1 = 0;
		count_2 = 0;
		count_3 = 0;
		count_4 = 0;

		%--------------------------------------------------
		[vector_train_accuracy, count_1] =....
		auxiliar(vector_train_accuracy,count_1,'vetortrain_accuracy',...   
		classificador, nohiddenlayers, numEscondidos, kernel);
		%--------------------------------------------------
		[vector_test_accuracy, count_2] =....
		auxiliar(vector_test_accuracy, count_2,'vetortest_accuracy',...     
		classificador, nohiddenlayers, numEscondidos, kernel);
		%--------------------------------------------------
		[vector_TrainingTime, count_3] =....
		auxiliar(vector_TrainingTime,count_3,'vetorTrainingTime',...    
		classificador, nohiddenlayers, numEscondidos, kernel);
		%--------------------------------------------------
		[vector_TestingTime,count_4] =....
		auxiliar(vector_TestingTime,count_4,'vetorTestingTime',...    
		classificador, nohiddenlayers, numEscondidos, kernel);
		%--------------------------------------------------   
		[mediatest_accuracy] = ...
		resultado_final_kernel(classificador,vector_train_accuracy,vector_test_accuracy,vector_TrainingTime,vector_TestingTime,kernel);
		
            
        if mediatest_accuracy>result_max
            global_kernel_max = kernel;
            result_max = mediatest_accuracy;
            nohiddenlayers_max = nohiddenlayers;
			numEscondidos_max = numEscondidos;
        end
%==========================================================================
function [matrix,count] =...
          auxiliar(...
          matrix,count,vetor_str,...
          classificador,nohiddenlayers,numEscondidos,kernel)						

	str = strcat(classificador,'/boxplot/',vetor_str,'_nohiddenlayers_', num2str(nohiddenlayers),'_numEscondidos_', num2str(numEscondidos),'_',kernel, '.txt');
    
    if(exist(str, 'file') == 2)
        temp = load(str);        
        for jj=1:numel(temp)
            count = count + 1;
            matrix(count,1) = temp(jj);
        end
    end
%==========================================================================
function kernel = kernel_str(u)	

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
            
%==========================================================================   
function montar_grafico(a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,classificador,vetor_str,q,n)

    x = cat(2,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11);

    for i=1:11
        group(i)=i;
    end

    ini = 1;
    for i=1:11
        positions(i) = ini;
        ini = ini + 0.25;
    end
    
    boxplot(x,group, 'positions', positions);
    h = findobj(gca,'Tag','Box');

    opacidade = .50;
    j=11;
    patch(get(h(j),'XData'),get(h(j),'YData'),[0,0,100/255],'FaceAlpha',opacidade);
    j = j-1;
	patch(get(h(j),'XData'),get(h(j),'YData'),[0,0,255/255],'FaceAlpha',opacidade);
    j = j-1;
	patch(get(h(j),'XData'),get(h(j),'YData'),[128/255,0,128/255],'FaceAlpha',opacidade);
    j = j-1;
	patch(get(h(j),'XData'),get(h(j),'YData'),[138/255,43/255,226/255],'FaceAlpha',opacidade);%blue violet
    j = j-1;
    patch(get(h(j),'XData'),get(h(j),'YData'),[128/255,0,0],'FaceAlpha', opacidade);
    j = j-1;
    patch(get(h(j),'XData'),get(h(j),'YData'),[139/255,69/255,19/255],'FaceAlpha',opacidade);%saddle brown
    j = j-1; 
    patch(get(h(j),'XData'),get(h(j),'YData'),[188/255,143/255,143/255],'FaceAlpha',opacidade);%rosy brown
    j = j-1;
	patch(get(h(j),'XData'),get(h(j),'YData'),[0,255/255,0],'FaceAlpha',opacidade);
    j = j-1;
    patch(get(h(j),'XData'),get(h(j),'YData'),[0,128/255,128/255],'FaceAlpha',opacidade);
    j = j-1;    
    patch(get(h(j),'XData'),get(h(j),'YData'),[0,128/255,0],'FaceAlpha',opacidade);
    j = j-1;
    patch(get(h(j),'XData'),get(h(j),'YData'),[128/255,128/255,0],'FaceAlpha',opacidade);


    set(gca,'xtick',[])

     [BL,BLicons] = legend(...
        'Batch training learning rules',...
        'Conjugate gradient with Powell-Beale restarts ',...
        'Conjugate gradient with Fletcher-Reeves',...
        'Conjugate gradient with Polak-Ribiere',...
        'Gradient descent backpropagation',...
        'Gradient descent with momentum',...
        'Gradient descent with adaptive learning',...
        'Gradient descent combined',...
        'One-step secant backpropagation',...
        'Resilient backpropagation (Rprop)',...
        'Scaled conjugate gradient backpropagation',...
        'location','eastoutside');   
        
    PatchInLegend = findobj(BLicons, 'type', 'patch');
    set(PatchInLegend, 'facea', 0.5)
    

	str = strcat(classificador,'/boxplot/ELM_boxplot_',vetor_str,'_nohiddenlayers_', num2str(q),'_numEscondidos', num2str(n),'.bmp');
	
    saveas(gcf,str);    
            
 

