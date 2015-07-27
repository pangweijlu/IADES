function plotZRXPdata(st_name, st_time, levels, lvl_low, lvl_high)

 if nargin < 3 % 5
     error('Not enough parametres!');
 end

 p = plot(lvl_low*ones(1, length(st_time)), ':b', 'LineWidth', 2);
 hold on
 
 p = plot(lvl_high*ones(1, length(st_time)), ':r', 'LineWidth', 2);
 hold on
 
 p = plot(levels);
 set(p, 'Color', 'cyan', 'LineWidth', 4);
 % set(p, 'Color', 'red', 'LineWidth', 4);
 
 set(legend('low', 'high', 'actual', 'Location', 'Best'), 'FontSize', 20);
 % set(legend('actual', 'Location', 'Best'), 'FontSize', 20);
 ylabel('Rivel Level (meters)', 'FontSize', 20);
 xlabel('Observations', 'FontSize', 20);
 gtitle = sprintf('%s, %s - %s', st_name, datestr(st_time(1)), ...
     datestr(st_time(length(st_time))));
 % title('Weisdale Burn, 25-29/10/2014', 'FontSize', 24);
 title(gtitle, 'FontSize', 24);
 set(gca, 'FontSize', 18);
 % pause;

end