(function() {
    'use strict';

    angular
        .module('openc3')
        .controller('GooglePlayReviewController', GooglePlayReviewController);

    function GooglePlayReviewController($http, ngTableParams, $uibModal, genericService, $interval, $scope) {
        var vm = this;

        vm.appselected = '';

        vm.isInterval = false;
        vm.hasDebugStatus = false;

        vm.debugswitch = function() {
          vm.hasDebugStatus = !vm.hasDebugStatus
        }
        
        vm.reload = function () {
            vm.loadover = false;
            $http.get('/api/ci/googleplay/review?appname=' + vm.appselected ).success(function(data){
                if (data.stat){
                    vm.dataTable = new ngTableParams({count:25}, {counts:[],data:data.data});
                    vm.loadover = true;
                }else {
                    swal({ title:'获取列表失败', text: data.info, type:'error' });
                }
            });
        };

        vm.applist = [];
        vm.reloadApp = function () {
            vm.loadAppover = false;
            $http.get('/api/ci/googleplay/review/app_package_name').success(function(data){
                if (data.stat){
                    vm.loadAppover = true;
                    vm.applist = data.data;
                    vm.applist = [{ "label": "All", value: '' }].concat(data.data);
                }else {
                    swal({ title:'获取列表失败', text: data.info, type:'error' });
                }
            });
        };

        vm.reloadApp();
 
        vm.reply = function (m) {
            $uibModal.open({
                templateUrl: 'app/pages/googleplayreview/reply.html',
                controller: 'GooglePlayReviewReplyController',
                controllerAs: 'googleplayreviewreply',
                backdrop: 'static',
                size: 'lg',
                keyboard: false,
                bindToController: true,
                resolve: {
                    data: function () { return m},
                    reload: function () { return vm.reload}
                }
            });
        };

        vm.reload();

        vm.handleChange = function (value) {
          vm.reload();
        }

        // 定时任务开关
        vm.handleOpenChange = function (type) {
          swal({
            title: `${!vm.isInterval ? '开启定时刷新？' : '暂停定时刷新？'}`,
            type: "warning",
            showCancelButton: true,
            confirmButtonColor: "#DD6B55",
            cancelButtonText: "取消",
            confirmButtonText: "确定",
            closeOnConfirm: true
          }, function () {
            vm.isInterval = !vm.isInterval
            let timer = $interval(function () {
              if (vm.isInterval) {
                vm.reload();
              }
            }, 15000);
            if (type === 'close') {
              $interval.cancel(timer)
            }
          });
        }


    }
})();
