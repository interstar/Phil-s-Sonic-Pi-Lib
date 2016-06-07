
# informal testing ... no unit-test framework here 

# Testing Parts
# Now expects these to be defined in Phil's Library
# https://github.com/interstar/Phil-s-Sonic-Pi-Lib/

ns = (ring 60,65,70,74)
ts = (ring 0.5, 0.5, 0.5, 0.5)
as = (line 1, 0, steps:100)


p = Part.new( ns, ts, as, nil )

p.start_play()
loop do
  if not p.has_next() then
    p.start_play()
  end
  
  n = p.next_()
  play n[:note], amp: n[:amp]
  sleep n[:sleep]
end


# Testing tri_env_mins
vs = tri_env_mins(1,0.5,0.5,1,1)
ss = tri_env_mins(9999, 1.0/60,1.0/60,5,1)

with_fx :ixi_techno, phase: 48, mix: 0.1 do
  with_fx :bitcrusher do |bc|
    with_synth :prophet do
      loop do
        control bc, sample_rate: ss.tick+1
        play_chord [[:f3, :as3, :c2],[:fs3, :b3, :e4, :g4]].choose, amp: vs.tick, attack: 0.3, decay: 1
        with_fx :echo, phase: 0.7, decay: 5 do
          sample :ambi_swoosh, decay: 1,  rate: [-0.6,0.9,-1.3].choose if one_in 4
        end
        sleep 1
      end
    end
  end
end


