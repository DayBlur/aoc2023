
classdef minheap < handle
    properties
        count
        nodes
    end
    methods
        function obj = minheap(numnodes, numvals)
            obj.count = 0;
            obj.nodes = zeros(numnodes,numvals);
        end
        
        function add(obj, nodes)
            for i=1:size(nodes,1)
                node = nodes(i,:);
                obj.count = obj.count + 1;
                idx = obj.count;
                obj.nodes(idx,:) = node;
                while idx > 1
                    p = floor(idx/2);
                    if obj.nodes(idx,1) < obj.nodes(p,1)
                        tmp = obj.nodes(p,:);
                        obj.nodes(p,:) = obj.nodes(idx,:);
                        obj.nodes(idx,:) = tmp;
                        idx = p;
                    else
                        break;
                    end        
                end
            end
        end
        
        function node = pop(obj)
            node = obj.nodes(1,:);
            obj.nodes(1,:) = obj.nodes(obj.count,:);
            obj.count = obj.count - 1;
            idx = 1;
            while idx < obj.count
                c = idx*2;
                if c > obj.count
                    break;
                end
                if c+1 <= obj.count && obj.nodes(c+1,1) < obj.nodes(c,1)
                    c = c + 1;
                end
                if obj.nodes(c,1) < obj.nodes(idx,1)
                    tmp = obj.nodes(c,:);
                    obj.nodes(c,:) = obj.nodes(idx,:);
                    obj.nodes(idx,:) = tmp;
                    idx = c;
                else
                    break;
                end        
            end
        end
    end
end