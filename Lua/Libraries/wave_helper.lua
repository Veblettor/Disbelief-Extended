WaveHelper = {}
WaveHelper.spawntimer = 0
WaveHelper.Events = 
{
    
    --[[{
        Event = function() DEBUG("OK") end;
        Fired = false;
        TriggerAt = 0.5;
    }--]]
}

WaveHelper.RepeatEvents = 
{
    --[[{
    Event = function() DEBUG("OK") end;
        Interval = 0.75;
        IntervalCount = 0;
        MaxInterval = 6;
        Start = 0;
    }--]]
};


function WaveHelper:AddEvent(event,triggerat)
    table.insert(self.Events, {Event = event, Fired = false, TriggerAt = triggerat})
end

function WaveHelper:AddRepeatEvent(event,interval,maxinterval)
    table.insert(self.RepeatEvents, {Start = self.spawntimer, IntervalCount = 0, Event = event, Interval = interval, MaxInterval = maxinterval})
end

function WaveHelper:Update()
    self.spawntimer = self.spawntimer + Time.dt

    for i,event in pairs(self.Events) do
        if self.spawntimer >= event.TriggerAt and not event.Fired then
            event.Fired = true
            event.Event()
        end
    end

    for i,event in pairs(self.RepeatEvents) do
        
       if self.spawntimer - event.Start >= event.Interval*(event.IntervalCount+1) then

        if event.MaxInterval == 0 then
            event.IntervalCount = event.IntervalCount + 1
            event.Event()
        elseif event.IntervalCount < event.MaxInterval then
            event.IntervalCount = event.IntervalCount + 1
            event.Event()
        end

       end--]]

    end

end

return WaveHelper