%==========================================================================	
function svm_boxplot_dados(custos_vetor_max, gammas_vetor_max, classes, classificador, total)
	
	%-----------------------------------------------------------------------
	u = 1;
	[a1,b1,c1,d1] = recupera_vetor(classificador,'linear', custos_vetor_max(u), gammas_vetor_max(u), total);
	u = u+1;
	[a2,b2,c2,d2] = recupera_vetor(classificador,'polynomial', custos_vetor_max(u), gammas_vetor_max(u), total);
	u = u+1;
	[a3,b3,c3,d3] = recupera_vetor(classificador,'rbf', custos_vetor_max(u), gammas_vetor_max(u), total);
	u = u+1;
	[a4,b4,c4,d4] = recupera_vetor(classificador,'sigmoid', custos_vetor_max(u), gammas_vetor_max(u), total);

	%----------------------------------------------------------------------
    a1 = a1*100;
	a2 = a2*100;
	a3 = a3*100;
	a4 = a4*100;

    b1 = b1*100;
	b2 = b2*100;
	b3 = b3*100;
	b4 = b4*100;
    %----------------------------------------------------------------------
	montar_grafico(a1,a2,a3,a4,classificador,'vetortrain_accuracy');
	montar_grafico(b1,b2,b3,b4,classificador,'vetortest_accuracy');
	montar_grafico(c1,c2,c3,c4,classificador,'vetorTrainingTime');
	montar_grafico(d1,d2,d3,d4,classificador,'vetorTestingTime');
    %----------------------------------------------------------------------    
%========================================================================== 
function [vector_train_accuracy,vector_test_accuracy,vector_TrainingTime,vector_TestingTime] =...
         recupera_vetor(classifier, kernel, custos, gammas, total)
     
    %----------------------------------------------------------------------
	vector_train_accuracy = [];
	vector_test_accuracy = [];
	vector_TrainingTime = [];
	vector_TestingTime = [];
	count_1 = 0;
	count_2 = 0;
	count_3 = 0;
	count_4 = 0;

    for concatenacao=1:1
        for iteracao=1:total
            %--------------------------------------------------
            [vector_train_accuracy, count_1] =....
            auxiliar(vector_train_accuracy,count_1,'vetortrain_accuracy',...   
            iteracao,classifier,kernel, custos, gammas);
            %--------------------------------------------------
            [vector_test_accuracy, count_2] =....
            auxiliar(vector_test_accuracy, count_2,'vetortest_accuracy',...     
            iteracao,classifier,kernel, custos, gammas);
            %--------------------------------------------------
            [vector_TrainingTime, count_3] =....
            auxiliar(vector_TrainingTime,count_3,'vetorTrainingTime',...    
            iteracao,classifier,kernel, custos, gammas);
            %--------------------------------------------------
            [vector_TestingTime,count_4] =....
            auxiliar(vector_TestingTime,count_4,'vetorTestingTime',...    
            iteracao,classifier,kernel, custos, gammas);
            %--------------------------------------------------  
        end
    end   
    %----------------------------------------------------------------------
             
%==========================================================================
function [vector,count] =...
         auxiliar(vector,count,vetor_str,...
         iteracao,classifier,kernel, custos, gammas)

    str = strcat(classifier,'/boxplot/',num2str(iteracao),'/',kernel,'/',vetor_str,'_custo_',num2str(custos),'_gamma_',num2str(gammas));

    if(exist(str, 'file') == 2)
        temp = load(str);
        for jj=1:numel(temp)
            count = count + 1;
            vector(count,1) = temp(jj);
        end 
    end
    
%==========================================================================
function kernel = kernel_str(u)	

		if u==1
			kernel = 'linear';
		elseif u==2
			kernel = 'polynomial';
		elseif u==3
			kernel = 'rbf';
		elseif u==4
			kernel = 'sigmoid';
        end
%==========================================================================   
function montar_grafico(a1,a2,a3,a4,classificador,vetor_str)

    %----------------------------------------------------------------------
    x = cat(2,a1,a2,a3,a4);
    
    for i=1:4
        group(i)=i;
    end
    
    ini = 1;
    for i=1:4
        positions(i) = ini;
        ini = ini + 0.25;
    end
    
    positions
   
    boxplot(x,group, 'positions', positions);
    h = findobj(gca,'Tag','Box');

    opacidade = .50;
    j=4;
    patch(get(h(j),'XData'),get(h(j),'YData'),[0,0,100/255],'FaceAlpha',opacidade);
    j = j-1;
	patch(get(h(j),'XData'),get(h(j),'YData'),[0,0,255/255],'FaceAlpha',opacidade);
    j = j-1;
	patch(get(h(j),'XData'),get(h(j),'YData'),[128/255,0,128/255],'FaceAlpha',opacidade);
    j = j-1;
	patch(get(h(j),'XData'),get(h(j),'YData'),[138/255,43/255,226/255],'FaceAlpha',opacidade);%blue violet
    
    set(gca,'xtick',[])
    
    
    [BL,BLicons] = legend(...
        'Linear',...
        'Polynomial',...
        'RBF',...
        'Sigmoid',...
        'location','eastoutside');
    PatchInLegend = findobj(BLicons, 'type', 'patch');
    set(PatchInLegend, 'facea', 0.5)
    

	str = strcat(classificador,'/boxplot/ELM_boxplot_',vetor_str,'.bmp');
	
    saveas(gcf,str);    
            
 

