
%==========================================================================
function mlp_confusao_dados(qtd_vetor, number_vetor, classes, classificador)

    str = strcat(classificador,'/confusao/MLP_confusao.txt');
	if exist(str, 'file') == 2
        delete(str);
    end
    
    str_perc = strcat(classificador,'/confusao/MLP_confusao_perc.txt');
	if exist(str_perc, 'file') == 2
        delete(str_perc);
    end
	
    for u=1:11
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
        elseif u==11
            kernel = 'trainscg';		
        end	
		%--------------------------------------------------
		for q_index=1:numel(qtd_vetor)
			q = qtd_vetor(q_index);
			n = number_vetor(q_index);
			%---------------------------------------------
            matrix_train_perc = [];
			matrix_test_perc = [];
			matrix_train = [];
			matrix_test = [];
			count_train = 0;
			count_test = 0;
			%----------------------------------------------   
			[matrix_train,matrix_train_perc,count_train] =...
			auxiliar(...
			matrix_train,matrix_train_perc,'train',count_train,...
			classificador,q,n,kernel);					
			%----------------------------------
			[matrix_test,matrix_test_perc, count_test] =...
			auxiliar(...
			matrix_test,matrix_test_perc,'test',count_test,...
			classificador,q,n,kernel);					
			%----------------------------------
			fid = fopen(str,'a');
			fprintf(fid,'===============================%s=========================\n',kernel);   
			fprintf(fid,'----------train (nohiddenlayer, numEscondidos) (%d,%d) total_iteracoes (train,test) (%d,%d)---------\n',q,n,count_train,count_test);            
			for jj=1:classes
				for ii=1:classes
					media = mean(matrix_train(:,jj,ii));
					desvio = std(matrix_train(:,jj,ii));
					fprintf(fid,'(%d,%d) %.2f std %.2f\n', jj,ii, media, desvio);
				end
			end
			
			fprintf(fid,'-----------test (nohiddenlayer, numEscondidos) (%d,%d) ----------------\n',q,n);     
			for jj=1:classes
				for ii=1:classes
					media = mean(matrix_test(:,jj,ii));
					desvio = std(matrix_test(:,jj,ii));
					fprintf(fid,'(%d,%d) %.2f std %.2f\n', jj,ii, media, desvio);
				end
			end
			%----------------------------------------------
			fie = fopen(str_perc,'a');
			fprintf(fie,'===============================%s=========================\n',kernel);   
			fprintf(fie,'----------train (nohiddenlayer, numEscondidos) (%d,%d) total_iteracoes (train,test) (%d,%d)---------\n',q,n,count_train,count_test);            
			for jj=1:classes
				for ii=1:classes
					media = mean(matrix_train_perc(:,jj,ii));
					desvio = std(matrix_train_perc(:,jj,ii));
					fprintf(fie,'(%d,%d) %.2f std %.2f\n', jj,ii, media, desvio);
				end
			end
			
			fprintf(fie,'-----------test (nohiddenlayer, numEscondidos) (%d,%d) ----------------\n',q,n);     
			for jj=1:classes
				for ii=1:classes
					media = mean(matrix_test_perc(:,jj,ii));
					desvio = std(matrix_test_perc(:,jj,ii));
					fprintf(fie,'(%d,%d) %.2f std %.2f\n', jj,ii, media, desvio);
				end
			end
			%----------------------------------------------
		end
	end
	fclose('all');
%==========================================================================
function [matrix,matrix_perc,count] =...
          auxiliar(...
          matrix,matrix_perc,vetor_str,count,...
          classificador,nohiddenlayers,numEscondidos,kernel)						

	sy = 2; 
    sx = 2;
	fold = 1; 
    
	str = strcat(classificador,'/confusao/vetor_C_',vetor_str,'_peso_',num2str(fold),'_nohiddenlayers_', num2str(nohiddenlayers),'_numEscondidos_', num2str(numEscondidos),'_',kernel, '.txt');
    %str
    while(exist(str, 'file') == 2)
        temp = load(str);        
        count = count + 1;        
        [sy,sx] = size(temp);
        for jj=1:sy
            for ii=1:sx
                matrix(count,jj,ii) = temp(jj,ii);
            end
        end
        fold = fold + 1;
       	str = strcat(classificador,'/confusao/vetor_C_',vetor_str,'_peso_',num2str(fold),'_nohiddenlayers_', num2str(nohiddenlayers),'_numEscondidos_', num2str(numEscondidos),'_',kernel, '.txt');
    end  
	%----------------------------------------------------------------------
    for fold=1:count
		for jj=1:sy
			for ii=1:sx
				%----------------------------------------------------------
				soma = 0;
				for kk=1:sy
					soma = soma + matrix(fold,kk,ii);
				end
				%----------------------------------------------------------
				matrix_perc(fold,jj,ii) = (matrix(fold,jj,ii)/soma)*100;
                if isnan(matrix_perc(fold,jj,ii)) matrix_perc(fold,jj,ii) = 0; end
            end
		end 
    end
	%----------------------------------------------------------------------
%==========================================================================


