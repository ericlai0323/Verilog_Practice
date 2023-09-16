module fx_pt_add (a,
                  b,
                  sum);
    
    parameter SGN     = 2;
    parameter WIDTH   = 4;
    parameter A_INT_W = 1;
    parameter B_INT_W = 3;
    
    input [WIDTH-1:0]  a,b;
    output [2*WIDTH :0] sum;
    
    reg compare;
    reg equal_zero;
    integer i;

    /*generate ---case*/
    generate
    reg [2*WIDTH :0] temp_a,temp_b;
    reg [2*WIDTH :0] temp_sum;
    reg [2*WIDTH-1:0] zero;

    assign sum = temp_sum;

    

    

    always @(SGN or a or b) begin

        for(i = 0; i<2*WIDTH-1; i=i+1)
        begin
            zero[i]=1'b0;
        end
        case(SGN)
            1'b0:
            begin
                temp_a = {{ WIDTH-A_INT_W+1 {1'b0}} ,a ,{A_INT_W{1'b0}} };
                temp_b = {{ WIDTH-B_INT_W+1 {1'b0}} ,b ,{B_INT_W{1'b0}} };
                temp_sum    = temp_a + temp_b;
            end
            1'b1:
            begin
                temp_a = {{a[WIDTH-1] == 1'b0 ? {WIDTH-A_INT_W+1 {1'b0}} :{WIDTH-A_INT_W+1 {1'b1}}} ,a ,{A_INT_W{1'b0}} };
                temp_b = {{b[WIDTH-1] == 1'b0 ? {WIDTH-B_INT_W+1 {1'b0}} :{WIDTH-B_INT_W+1 {1'b1}}} ,b ,{B_INT_W{1'b0}} };
                temp_sum    = temp_a + temp_b;
            end
            default:
            begin
                temp_a = { {a[WIDTH-1] == 1'b0 ? 1'b0 :1'b1} ,{WIDTH-A_INT_W+1{1'b0}},a[WIDTH-2:0] ,{A_INT_W{1'b0}} };
                temp_b = { {b[WIDTH-1] == 1'b0 ? 1'b0 :1'b1} ,{WIDTH-B_INT_W+1{1'b0}},b[WIDTH-2:0] ,{B_INT_W{1'b0}} };
                
                compare = (temp_a[2*WIDTH-1:0] < temp_b[2*WIDTH-1:0])? 1'b0 : 1'b1;
                equal_zero = ((temp_a[2*WIDTH-1:0] == zero[2*WIDTH-1:0]) && ((temp_b[2*WIDTH-1:0]) == zero[2*WIDTH-1:0]))? 1'b0 : 1'b1;

                casez ({temp_a[2*WIDTH],temp_b[2*WIDTH],compare,equal_zero})
                    4'b00zz: begin
                        temp_sum          = temp_a + temp_b;
                        temp_sum[2*WIDTH] = 0;
                    end
                    
                    4'b010z: begin
                        temp_b       = ~temp_b +1;
                        temp_sum          = temp_a + temp_b;
                        temp_sum          = ~temp_sum + 1;
                        temp_sum[2*WIDTH] = 1;
                    end
                    
                    4'b011z: begin
                        temp_b       = ~temp_b +1;
                        temp_sum          = temp_a + temp_b;
                        temp_sum[2*WIDTH] = 0;
                    end
                    
                    4'b100z: begin
                        temp_a       = ~temp_a +1;
                        temp_sum          = temp_a + temp_b;
                        temp_sum[2*WIDTH] = 0;
                    end
                    4'b101z: begin
                        temp_a = ~temp_a +1;
                        temp_sum    = temp_a + temp_b; //10~
                        
                        temp_sum          = ~temp_sum + 1;
                        temp_sum[2*WIDTH] = (temp_sum[2*WIDTH-1:0] == 0) ? 1'b0 : 1'b1;
                    end
                    4'b11z0: begin
                        temp_sum          = temp_a + temp_b;
                        temp_sum[2*WIDTH] = 1;
                    end
                    4'b11z1: begin
                        temp_sum          = temp_a + temp_b;
                        temp_sum[2*WIDTH] = 1;                       
                        
                        // temp_sum[2*WIDTH-1:0] = zero[2*WIDTH-1:0];
                        // temp_sum[2*WIDTH] = 0;
                    end
                endcase
            end
        endcase

    end
    
    endgenerate
    
    
endmodule
