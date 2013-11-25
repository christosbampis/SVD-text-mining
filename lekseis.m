function out=lekseis(f)

file=fopen(f);
lekseis=textscan(file,'%s');
fclose(file);

for i=1:numel(lekseis{1,1})
    
    w=isstrprop(lekseis{1,1}{i,1},'alpha')==0;
    
    if sum(w)>=1 || size(lekseis{1,1}{i,1}, 2) <= 3
        
        lekseis{1,1}{i,1}='';
        
    end;
    
end

terms=unique(lekseis{1,1});
% bgazw to keno sthn arxh pou 8a exei apo ta erase
terms=terms(2:end);
s=size(terms,1);

tf=zeros(1,s);

% sugkrinw oles tis monadikes me tis proteres gia na brw suxnothtes twn
% monadikwn entos twn arxikwn
for i=1:s
    
    for j=1:numel(lekseis{1,1})
        
        if strcmp(lekseis{1,1}(j),terms{i})
            
                tf(i)=tf(i)+1;
                
        end
         
    end
    
end

[sort_tf,sort_ind]=sort(tf,'descend');

out={'ËÅÎÇ' 'tf'};

for i=1:length(sort_tf)
    
    out{i+1,1}=terms{sort_ind(i)};
    out{i+1,2}=sort_tf(i);
    
end



