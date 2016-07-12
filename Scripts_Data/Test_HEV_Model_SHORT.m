% Copyright 2011-2016 The MathWorks, Inc.

expModel = 'HEV_SeriesParallel';
open_system(expModel);

ModelVariants = {'System Level' 'Mean Value' 'Detailed'};
BattVariants = {'Predefined' 'Generic'};
VehVariants = {'Simple' 'Full'};

SimDuration = [max(UrbanCycle1.time) max(UrbanCycle2.time) max(UrbanCycle3.time)];

for MV_ind = 1:1

    MV_str = char(ModelVariants(MV_ind));
    MV_name = strrep(MV_str,' ','_');
    
    for DC_ind=1:3
        
        for Veh_ind = 1:1 %length(VehVariants)
            Veh_str = char(VehVariants(Veh_ind));
            Veh_name = strrep(Veh_str,' ','_');
            set_param([expModel '/Vehicle Dynamics'],'BlockChoice',Veh_str);
            
            for Batt_ind=1:1 %length(BattVariants)
                Batt_str = char(BattVariants(Batt_ind));
                Batt_name = strrep(Batt_str,' ','_');
                
                set_param(expModel,'StopTime',num2str(SimDuration(DC_ind)));
                Drive_Cycle_Num = DC_ind;
                set_param([expModel '/Electrical'],'BlockChoice',MV_str);
                
                set_param([expModel '/Electrical/' MV_str '/Battery'],'BlockChoice',Batt_str);
                disp(['Simulating UC' num2str(DC_ind) ', ' get_param([expModel '/Electrical'],'BlockChoice') ', '...
                    get_param([expModel '/Vehicle Dynamics'],'BlockChoice') ' Vehicle, ',... 
                    get_param([expModel '/Electrical/' MV_str '/Battery'],'BlockChoice') ' Battery'] );
                sim(expModel);
                
                eval([MV_name '.Electrical = Electricals;']);
                eval([MV_name '.Car = Car;']);
                eval([MV_name '.Generator = Generator;']);
                eval([MV_name '.Motor = Motor;']);
                eval([MV_name '.Control_Logic = Control_Logic;']);
                eval([MV_name '.DCDC_Conv = DCDC_Temp;']);
                
                %SaveFolder = [SaveFolderRoot '\UC' num2str(DC_ind) '\' MV_name];
                %SaveFileName = [SaveFolder '\' MV_name '_DATA_UC' num2str(DC_ind) '_Veh' num2str(Veh_ind) '_Batt' num2str(Batt_ind)];
                %disp(['save ' SaveFileName ' ' MV_name]);
                %eval(['save ' SaveFileName ' ' MV_name]);
                eval(['clear ' MV_name ' Electricals Car Generator Motor Control_Logic']);
            end
        end
    end
end

open('HEV_Model_Report_SHORT.html');
