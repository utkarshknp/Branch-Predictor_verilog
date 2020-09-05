`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/08/2019 01:14:55 AM
// Design Name: 
// Module Name: branch_predictor
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module branch_predictor(input push_button,input outcome, input clk, input reset, input display, output out, output check, output prediction);
reg [1:0]NN=2'b00;
reg [1:0]NT=2'b00;
reg [1:0]TN=2'b11;
reg [1:0]TT=2'b11;
reg [1:0]BHT=2'b00;
reg state=1'b0;
reg prediction=1'b0;
reg check=1'b0;
reg out=8'b00000000;
wire clk_divided;
parameter predict=1'b0, branch=1'b1;
clk_reduced_sec(clk,clk_divided);
always @(posedge clk_divided)
begin
    if(display)
        begin
        check=~check;
        out={NN,NT,TN,TT};
        end
    else if(reset)
        begin
        out=8'b0;
        check=~check;
        NN=2'b00;			//Initial values of NN, NT,TN,TT are given in question
        NT=2'b00;
        TN=2'b11;
        TT=2'b11;
        BHT=2'b00;			//last 2 outputs are remembered
        state=1'b0;			// state decides whether predict mode is on or branch mode is on
        prediction=1'b0;
        end
    else
        begin
            case(state)			//if state==1 branch and if state==0 predict mode is on.
                predict:
                    begin
                    if(BHT==2'b00)	//if BHT==00 then value of NN will predict
                        begin
                        if(NN==2'b00 || NN==2'b01)
                            begin
                            prediction=1'b0;
                            end
                        else
                            begin
                            prediction=1'b1;
                            end
                        end
                    else if(BHT==2'b01) //If BHT==01 then NT will be used for predict
                        begin
                        if(NT==2'b00 || NT==2'b01)
                            begin
                            prediction=1'b0;
                            end
                        else
                            begin
                            prediction=1'b1;
                            end                        
                        end
                    else if(BHT==2'b10)     //If BHT==10 then TN will be used for predict
                       begin
                        if(TN==2'b00 || TN==2'b01)
                            begin
                            prediction=1'b0;
                            end
                        else
                            begin
                            prediction=1'b1;
                            end                        
                        end
                    else		//If BHT is not 00,01 or 10, then TT will be used for predict since only 11 is possible
                        begin
                        if(TT==2'b00 || TT==2'b01)
                            begin
                            prediction=1'b0;
                            end
                        else
                            begin
                            prediction=1'b1;
                            end                        
                        end 
                    out={prediction,prediction,prediction,prediction,prediction,prediction,prediction,prediction};
                    state=branch; 
                    end
                branch:
                    begin
                    out=8'b0;
                    if(push_button)
                        begin
                             check=~check;
                             if(outcome==prediction)    		//If prediction was true
                                begin
                                    if(BHT==2'b00)			//If BHT=00 NN's value will have to be reduced.
                                        begin
                                        if(NN==2'b11)
                                            NN=2'b10;
                                        else
                                            NN=2'b00;
                                        end
                                    else if(BHT==2'b01)			//If BHT=01 NT's value will have to be reduced.
                                        begin
                                        if(NT==2'b11)
                                            NT=2'b10;
                                        else
                                            NT=2'b00;
                                        end
                                    else if(BHT==2'b10)			//If BHT=10 TN's value will have to be increased.
                                        begin
                                        if(TN==2'b00)
                                            TN=2'b01;
                                        else
                                            TN=2'b11;
                                        end
                                    else if(BHT==2'b11)			//If BHT=11 TT's value will have to be increased.
                                        begin
                                        if(TT==2'b00)
                                            TT=2'b01;
                                        else
                                            TT=2'b11;
                                        end
                                end
                             else					//if outcome was not equal to prediction
                                begin						
                                    if(BHT==2'b00)			//If BHT=00 NN's value will have to be increased.
                                        begin
                                        if(NN==2'b00)
                                            NN=2'b01;
                                        else
                                            NN=2'b11;
                                        end
                                    else if(BHT==2'b01)			//If BHT=01 NT's value will have to be increased.
                                        begin
                                        if(NT==2'b00)
                                            NT=2'b01;
                                        else
                                            NT=2'b11;
                                        end
                                    else if(BHT==2'b10)			//If BHT=10 TN's value will have to be reduced.
                                        begin
                                        if(TN==2'b11)
                                            TN=2'b10;
                                        else
                                            TN=2'b00;
                                        end
                                    else if(BHT==2'b11)			//If BHT=11 TT's value will have to be reduced.
                                        begin
                                        if(TT==2'b11)
                                            TT=2'b10;
                                        else
                                            TT=2'b00;
                                        end
                                    
                                end
                        BHT={BHT[0],outcome};					//	outcome will be added to BHT
                        state=predict;
                        end
                    else
                        begin
                        state=branch;
                        end
                    end
                default:							//If nothing is entered
                    begin
                    state=branch;
                    end
        
        endcase
        
    end

end


endmodule
