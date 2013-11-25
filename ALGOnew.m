function [call,idxall,idxall_secondary] = ALGO(fileout,out_LSA,struct,n_train,n_test,v2all,type,dim,U,out_LSA_svd)

d=[];

for k=1:n_test
    
    vectorall=[];
    vectorall_LSA=[];   
    string=['test' num2str(k) '.txt']; 
    results=lekseis(string);
    
    for i=2:size(results(:,1),1)
   
    A=results(i,1);    f=size(struct(:,1),1);
    B=struct(2:f,1);    [x,y]=ismember(A,B);
    
    if x==1
        
        help=zeros(1,size(out_LSA,2));
        help(y)=1;
        vector=cell2mat(results(i,2))*help;
        vectorall=[vectorall ; vector];
        vector_LSA=vector*(log(n_train/(1+sum(v2all(y,:)))));
        vectorall_LSA=[vectorall_LSA ; vector_LSA];
        
    end;
    
end;

    d=[d ; sum(vectorall_LSA)];

end;

call=[];    idxall=[];    idxall_secondary=[];

for k=1:n_test
    
    if type==1

        vectorall_LSA1=U'*d(k,:)';
      
    end;

    c=[];
    
    if type==0      vectorall_LSA1=d(k,:);    g=-500;    end;
  
if type==1

    for j=1:size(out_LSA,1)                
        c(j)=out_LSA_svd(j,:)*vectorall_LSA1/(norm(vectorall_LSA1)*norm(out_LSA_svd(j,:))); 
    end;
    
    disp('me svd'),disp(size(out_LSA_svd(j-1,:))),disp(size(vectorall_LSA1));

else

    for j=1:size(out_LSA,1)              
        c(j)=vectorall_LSA1*out_LSA(j,:)'/(norm(vectorall_LSA1)*norm(out_LSA(j,:)'));      
    end;
    
    disp('oxi svd'),disp(size(vectorall_LSA1)),disp(size(out_LSA(j-1,:)'));

end;
    
    [~,idx]=sort(abs(c-1));
 
    call=[call ; c];    idxall=[idxall ; idx(1)];   idxall_secondary=[idxall_secondary ; idx];
    
    fprintf(fileout,'file test%s.txt is matched best from file %s.txt (order of relevance descending: %s)\n',num2str(k),num2str(idx(1)),num2str(idx));
      
end;

fprintf(fileout,'\n');

end


