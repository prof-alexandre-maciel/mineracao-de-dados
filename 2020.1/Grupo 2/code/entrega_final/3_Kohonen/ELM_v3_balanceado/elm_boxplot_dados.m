%==========================================================================	
function elm_boxplot_dados(NumberofHiddenNeurons_vetor_max, custos_vetor_max, gammas_vetor_max, classificador, total)
	
	%-----------------------------------------------------------------------
	u = 1;
	[a1,b1,c1,d1] = recupera_vetor(classificador,'RBF_kernel', NumberofHiddenNeurons_vetor_max(u), custos_vetor_max(u), gammas_vetor_max(u), total);
	u = u+1;
	[a2,b2,c2,d2] = recupera_vetor(classificador,'lin_kernel', NumberofHiddenNeurons_vetor_max(u), custos_vetor_max(u), gammas_vetor_max(u), total);
	u = u+1;
	[a3,b3,c3,d3] = recupera_vetor(classificador,'poly_kernel', NumberofHiddenNeurons_vetor_max(u), custos_vetor_max(u), gammas_vetor_max(u), total);
	u = u+1;
	[a4,b4,c4,d4] = recupera_vetor(classificador,'wav_kernel', NumberofHiddenNeurons_vetor_max(u), custos_vetor_max(u), gammas_vetor_max(u), total);
	u = u+1;
	[a5,b5,c5,d5] = recupera_vetor(classificador,'sigmoid', NumberofHiddenNeurons_vetor_max(u), custos_vetor_max(u), gammas_vetor_max(u), total);
	u = u+1;
	[a6,b6,c6,d6] = recupera_vetor(classificador,'sine', NumberofHiddenNeurons_vetor_max(u), custos_vetor_max(u), gammas_vetor_max(u), total);
	u = u+1;
	[a7,b7,c7,d7] = recupera_vetor(classificador,'hardlim', NumberofHiddenNeurons_vetor_max(u), custos_vetor_max(u), gammas_vetor_max(u), total);
	u = u+1;
	[a8,b8,c8,d8] = recupera_vetor(classificador,'tribas', NumberofHiddenNeurons_vetor_max(u), custos_vetor_max(u), gammas_vetor_max(u), total);
	u = u+1;
	[a9,b9,c9,d9] = recupera_vetor(classificador,'dilatacao', NumberofHiddenNeurons_vetor_max(u), custos_vetor_max(u), gammas_vetor_max(u), total);
	u = u+1;
	[a10,b10,c10,d10] = recupera_vetor(classificador,'erosao', NumberofHiddenNeurons_vetor_max(u), custos_vetor_max(u), gammas_vetor_max(u), total);
	u = u+1;
	[a11,b11,c11,d11] = recupera_vetor(classificador,'dilatacao_classica', NumberofHiddenNeurons_vetor_max(u), custos_vetor_max(u), gammas_vetor_max(u), total);
	u = u+1;
	[a12,b12,c12,d12] = recupera_vetor(classificador,'erosao_classica', NumberofHiddenNeurons_vetor_max(u), custos_vetor_max(u), gammas_vetor_max(u), total);
	u = u+1;
	[a13,b13,c13,d13] = recupera_vetor(classificador,'dilatacao_bitwise', NumberofHiddenNeurons_vetor_max(u), custos_vetor_max(u), gammas_vetor_max(u), total);
	u = u+1;
	[a14,b14,c14,d14] = recupera_vetor(classificador,'erosao_bitwise', NumberofHiddenNeurons_vetor_max(u), custos_vetor_max(u), gammas_vetor_max(u), total);
	%----------------------------------------------------------------------
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
	a12 = a12*100;
    a13 = a13*100;
	a14 = a14*100;
	
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
	b12 = b12*100;
	b13 = b13*100;
	b14 = b14*100;
    %----------------------------------------------------------------------
    [a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14] = ...
    equal_amostras(a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14);
    [b1,b2,b3,b4,b5,b6,b7,b8,b9,b10,b11,b12,b13,b14] = ...
    equal_amostras(b1,b2,b3,b4,b5,b6,b7,b8,b9,b10,b11,b12,b13,b14);
    [c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11,c12,c13,c14] = ...
    equal_amostras(c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11,c12,c13,c14);
    [d1,d2,d3,d4,d5,d6,d7,d8,d9,d10,d11,d12,d13,d14] = ...
    equal_amostras(d1,d2,d3,d4,d5,d6,d7,d8,d9,d10,d11,d12,d13,d14);
    %----------------------------------------------------------------------
	montar_grafico(a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14,classificador,'vetortrain_accuracy');
	montar_grafico(b1,b2,b3,b4,b5,b6,b7,b8,b9,b10,b11,b12,b13,b14,classificador,'vetortest_accuracy');
	montar_grafico(c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11,c12,c13,c14,classificador,'vetorTrainingTime');
	montar_grafico(d1,d2,d3,d4,d5,d6,d7,d8,d9,d10,d11,d12,d13,d14,classificador,'vetorTestingTime');
    %----------------------------------------------------------------------    
%==========================================================================     
function [a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14] = ...
         equal_amostras(a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14)
     
     maximo = max([numel(a1),numel(a2),numel(a3),numel(a4),numel(a5),numel(a6),numel(a7),numel(a8),numel(a9),numel(a10),numel(a11),numel(a12),numel(a13),numel(a14)]);

     if(numel(a1)~=maximo)
         factor = round(maximo/numel(a1));
         a1 = repmat(a1,factor,1);
     end           
     if(numel(a2)~=maximo)
         factor = round(maximo/numel(a2));
         a2 = repmat(a2,factor,1);
     end  
     if(numel(a3)~=maximo)
         factor = round(maximo/numel(a3));
         a3 = repmat(a3,factor,1);
     end  
     if(numel(a4)~=maximo)
         factor = round(maximo/numel(a4));
         a4 = repmat(a4,factor,1);
     end  
     if(numel(a5)~=maximo)
         factor = round(maximo/numel(a5));
         a5 = repmat(a5,factor,1);
     end           
     if(numel(a6)~=maximo)
         factor = round(maximo/numel(a6));
         a6 = repmat(a6,factor,1);
     end  
     if(numel(a7)~=maximo)
         factor = round(maximo/numel(a7));
         a7 = repmat(a7,factor,1);
     end  
     if(numel(a8)~=maximo)
         factor = round(maximo/numel(a8));
         a8 = repmat(a8,factor,1);
     end  
      if(numel(a9)~=maximo)
         factor = round(maximo/numel(a9));
         a9 = repmat(a9,factor,1);
     end           
     if(numel(a10)~=maximo)
         factor = round(maximo/numel(a10));
         a10 = repmat(a10,factor,1);
     end  
     if(numel(a11)~=maximo)
         factor = round(maximo/numel(a11));
         a11 = repmat(a11,factor,1);
     end  
     if(numel(a12)~=maximo)
         factor = round(maximo/numel(a12));
         a12 = repmat(a12,factor,1);
     end      
     if(numel(a13)~=maximo)
         factor = round(maximo/numel(a13));
         a13 = repmat(a13,factor,1);
     end   
     if(numel(a14)~=maximo)
         factor = round(maximo/numel(a14));
         a14 = repmat(a14,factor,1);
     end   	 
%========================================================================== 
function [vector_train_accuracy,vector_test_accuracy,vector_TrainingTime,vector_TestingTime] =...
         recupera_vetor(classifier,kernel, NumberofHiddenNeurons, custos, gammas, total)
     
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
            iteracao,classifier,kernel, NumberofHiddenNeurons, custos, gammas);
            %--------------------------------------------------
            [vector_test_accuracy, count_2] =....
            auxiliar(vector_test_accuracy, count_2,'vetortest_accuracy',...     
            iteracao,classifier,kernel, NumberofHiddenNeurons, custos, gammas);
            %--------------------------------------------------
            [vector_TrainingTime, count_3] =....
            auxiliar(vector_TrainingTime,count_3,'vetorTrainingTime',...    
            iteracao,classifier,kernel, NumberofHiddenNeurons, custos, gammas);
            %--------------------------------------------------
            [vector_TestingTime,count_4] =....
            auxiliar(vector_TestingTime,count_4,'vetorTestingTime',...    
            iteracao,classifier,kernel, NumberofHiddenNeurons, custos, gammas);
            %--------------------------------------------------  
        end
    end   
    %----------------------------------------------------------------------
             
%==========================================================================
function [vector,count] =...
         auxiliar(vector,count,vetor_str,...
         iteracao,classifier,kernel, escondida, custos, gammas)

    str = strcat(classifier,'/boxplot/',num2str(iteracao),'/',kernel,'/',vetor_str,'_escondida_',num2str(escondida),'_custo_',num2str(custos),'_gamma_',num2str(gammas));

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
		kernel = 'RBF_kernel';
	elseif u==2
		kernel = 'lin_kernel';
	elseif u==3
		kernel = 'poly_kernel';
	elseif u==4
		kernel = 'wav_kernel';
	elseif u==5
		kernel = 'sigmoid';
	elseif u==6
		kernel = 'sine';
	elseif u==7
		kernel = 'hardlim';
	elseif u==8    
		kernel = 'tribas';
	elseif u==9
		kernel = 'dilatacao';
	elseif u==10
		kernel = 'erosao';
	elseif u==11
		kernel = 'dilatacao_classica';
	elseif u==12
		kernel = 'erosao_classica';			
	elseif u==13
		kernel = 'dilatacao_bitwise';
	elseif u==14
		kernel = 'erosao_bitwise';			
     end
            
%==========================================================================   
function montar_grafico(a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14,classificador,vetor_str)

    x = cat(2,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14);

    for i=1:14
        group(i)=i;
    end

    ini = 1;
    for i=1:14
        positions(i) = ini;
        ini = ini + 0.25;
    end
    
    boxplot(x,group, 'positions', positions);
    h = findobj(gca,'Tag','Box');

    opacidade = .50;
    j=14;
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
    j = j-1;
    patch(get(h(j),'XData'),get(h(j),'YData'),[189/255,183/255,107/255],'FaceAlpha',opacidade);%dark khaki
    j = j-1;
    patch(get(h(j),'XData'),get(h(j),'YData'),[0,0,0],'FaceAlpha',opacidade);%dark gray / dark grey
    j = j-1;
    patch(get(h(j),'XData'),get(h(j),'YData'),[112/255,128/255,144/255],'FaceAlpha',opacidade);%slate gray
	
    set(gca,'xtick',[])

     [BL,BLicons] = legend(...
        'RBF',...
        'Linear',...
        'Polynomial',...
        'Wavelet',...
        'Sigmoid',...
        'Sine',...
        'Hard limit',...
        'Tribas',...
        'Fuzzy-Dilation',...
        'Fuzzy-Erosion',...
        'Classical Dilation',...
        'Classical Erosion',...
		'Bitwise-Dilation',...
        'Bitwise-Erosion',...
        'location','eastoutside');   
        
    PatchInLegend = findobj(BLicons, 'type', 'patch');
    set(PatchInLegend, 'facea', 0.5)
    

	str = strcat(classificador,'/boxplot/ELM_boxplot_',vetor_str,'.bmp');
	
    saveas(gcf,str);    
            
 

