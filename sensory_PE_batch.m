%%% Make sure that an installation of SPM12 is included in your Matlab PATH
%%% SPM12 can be obtained from https://www.fil.ion.ucl.ac.uk/spm/software/

close all;
 
n_traj = 100;
n_plot = 10;

if exist('trajectories.mat') == 2
    
    load('trajectories.mat')
    
else

    for i = 1:n_traj

       DEM = sensory_PE(1.5+0.01*randn(),1.5+0.01*randn(),0,0,30.0+20.0*rand(),1.0,20);
       x    = DEM.pU.x{1};
       
       J = -DEM.J(2:end);

       size(x)

       px = x(1,:);
       py = x(2,:);

       if i == 1
           xs = zeros(n_traj, length(px));
           ys = zeros(n_traj, length(py));
           Js = zeros(n_traj, length(J));
       end

       xs(i,:) = px;
       ys(i,:) = py;
       Js(i,:) = J;

    end
    
    save('trajectories.mat','xs','ys','Js')
    
end

trajectories_figure = figure('name','TRAJECTORIES');

s = subplot(2,2,1);

set(s, 'XLim', [-0.2, 1.6])
set(s, 'YLim', [-0.2, 1.6])

c = [1 .8 .7]*(0.8);

for i = 1:n_plot
    
    hold on;
    plot(xs(i,:),ys(i,:),'LineWidth',0.1,'color',c);
    hold off;
    
end

labels = {};
n_labels = 7;
label_step = 10;

cmap = parula(n_labels);

ticks = [];

for i = 1:n_plot
    
    hold on;
   
    for j = 0:(n_labels-1)
        plot(xs(i,j*label_step+1),ys(i,j*label_step+1),'.','MarkerSize',10.0,'color',cmap(j+1,:));
        
        if i == 1
            labels = [labels sprintf('%d',j*label_step)];
            ticks = [ticks 1.0/(n_labels)*j + 0.5/(n_labels)];
        end
    end
    
    hold off;
    
end

colormap(cmap)
h = colorbar();
set(h,'TickLabels',labels);
set(h,'Ticks',ticks);
set(h,'TickLength',0.0);
h.Title.String = {'Time','step'};
xlabel('$X$','Interpreter','latex')
ylabel('$Y$','Interpreter','latex')
title(sprintf('Trajectories of %d individuals',n_plot))

n_steps = size(xs,2)

corrs = zeros(1,n_steps);
varsx = zeros(1,n_steps);
varsy = zeros(1,n_steps);

for i = 1:n_steps
    corrs(i) = corr(xs(:,i),ys(:,i));
    varsx(i) = var(xs(:,i));
    varsy(i) = var(ys(:,i));
end

subplot(2,2,2)
plot(mean(Js,1))
xlabel('Time step $t$','Interpreter','latex')
ylabel('$\left<F(t)\right>_{\mathrm{population}}$','Interpreter','latex')
title({'Time course of population mean of','variational free energy'})

subplot(2,2,3)
plot(corrs)
xlabel('Time step $t$','Interpreter','latex')
ylabel('Correlation','Interpreter','latex')
title({'Time course of correlation','between variables X and Y','within population'})

subplot(2,2,4)
plot(varsx);
hold on;
plot(varsy);
hold off;
legend({'$X$','$Y$'},'Interpreter','latex')
xlabel('Time step $t$','Interpreter','latex')
ylabel('Variance','Interpreter','latex')
title({'Time course of variance','within population'})

set(gcf, 'PaperUnits', 'centimeters');
set(gcf, 'PaperSize', [24 16]);
set(gcf, 'PaperPositionMode', 'manual');
set(gcf, 'PaperPosition', [0 0 24 16]);
saveas(trajectories_figure,'trajectories_figure.pdf')