clear all; clc; close all;
 
addpath('test_data');
addpath('train_data_2');

a=inputdlg({'Give number of test files'},'Input:',1,{'1'});
n_test=str2num(a{1});
list=dir('train_data_2');
n_train=0;
for i=1:numel(list)
    
    if (strcmp(list(i).name,'.')==0)&& (strcmp(list(i).name,'..')==0)
        n_train=n_train+1;    
    end;
    
end;
clear list a;

% h=waitbar(0,sprintf('Creating Train Database, please wait...'));
% tic1=tic;
% create_train(n_train)
% pre=toc(tic1);
% close(h)

tipota=0;
load train.mat

dim=15; 
fileout=fopen('results.txt','wt');
ticsvd=tic;
[U,g]=svd_r(out_LSA',dim);
time_preparesvd=toc(ticsvd);

for k=1:n_train
    
    out_LSA_svd(k,:)=U'*out_LSA(k,:)';
    
end;

total=1;
elapsedtime_svd=[];
elapsedtime_no_svd=[];
allaccuracymain=[];
allaccuracysecondary=[];
h=waitbar(0,sprintf('Running %s simulations, please wait...',num2str(total)));
   
for i=1:total;
    
    fprintf(fileout,'START SIMULATION No %g \n',i);
    fprintf(fileout,'/////////////////     TESTING PHASE, %g TEST TEXT FILES     /////////////////\r\n',n_test);
    fprintf(fileout,'/////////////////     NO SVD     /////////////////\r\n');

    tic2=tic;

    [c1,i1,k1]=ALGOnew(fileout,out_LSA,struct,n_train,n_test,v2all,0,dim,tipota,tipota);

    x=toc(tic2);
    
    elapsedtime_no_svd=[elapsedtime_no_svd x];

    fprintf(fileout,'/////////////////     SVD WITH %g DIMENSION    /////////////////\r\n',dim);

    tic3=tic;

    [c2,i2,k2]=ALGOnew(fileout,out_LSA,struct,n_train,n_test,v2all,1,dim,U,out_LSA_svd);

    x=toc(tic3);
    
    elapsedtime_svd=[elapsedtime_svd x];

    y=(i1==i2);    
    z=(k1==k2);
    svd_main_accuracy=sum(y)/length(y);    
    svd_secondary_accuracy=sum(z(:))/length(z(:));
    
    fprintf(fileout,'/////////////////     RESULTS     /////////////////\r\n');
    fprintf(fileout,'main svd was %s, and secondary was %s time gain %s sec maximum dimension: %g\r\n',[num2str(svd_main_accuracy*100) '%'],[num2str(svd_secondary_accuracy*100) '%'],num2str(elapsedtime_no_svd(i)-elapsedtime_svd(i)),g);
    fprintf(fileout,'STOP SIMULATION No %g \r\n\n',i);
      
    waitbar(i/total,h,sprintf('Running %s simulations, please wait...(%s complete)',num2str(total),[num2str(i/total*100) '%']))
    
    allaccuracymain=[allaccuracymain ; svd_main_accuracy];
    allaccuracysecondary=[allaccuracysecondary ; svd_secondary_accuracy];
    
end;

close(h)
fclose(fileout);
gain=mean(elapsedtime_no_svd)-mean(elapsedtime_svd)
