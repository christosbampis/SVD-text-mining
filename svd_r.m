function [U,g]=svd_r(A,rdc)                             

    X=A'*A;
    X=max(X,X');   
    [V,e]=eig(X);
    e=diag(e);
    [~,index]=sort(-e);
    e=e(index);
    V=V(:,index);
    g=length(e);
    
    if rdc<length(e)
        e=e(1:rdc);
        V=V(:,1:rdc);
    end
    
    g1=length(e);
    e_root=e.^.5;
    S=spdiags(e_root,0,g1,g1);
    e_root_inv=e_root.^-1;
    U=A*(V.*repmat(e_root_inv',size(V,1),1));
    
end



