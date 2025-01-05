(function () {
    'use strict';
    angular
        .module('openc3')
        .controller('GooglePlayReviewReplyController', GooglePlayReviewReplyController);

    function GooglePlayReviewReplyController( $state, $http, ngTableParams, $uibModalInstance, $scope, resoureceService, $injector, reload, data ) {

        var vm = this;

        var toastr = toastr || $injector.get('toastr');

        vm.data = data;
        vm.postdata = {};

vm.replycontent = '';
        vm.cancel = function(){ $uibModalInstance.dismiss()};

        vm.add = function(){
            $http.post('/api/ci/v2/c3mc/googleplay/review/reply', { "callback": data.callback, "review_id":data.review_id, "text":vm.replycontent} ).success(function(data){
                if(data.stat == true) {
                    vm.cancel();
                    reload();
                } else { swal({ title: "添加失败!", text: data.info, type:'error' }); }

            });
        };

var id=0;
        vm.reload = function () {
            vm.loadover = false
            $http.get('/api/agent/cloudmon/' + id ).then(
                function successCallback(response) {
                    if (response.data.stat){
                        vm.postdata = response.data.data
                        vm.loadover = true
                    }else {
                        swal('获取信息失败', response.data.info, 'error' );
                    }
                },
                function errorCallback (response ){
                    swal('获取信息失败', response.status, 'error' );
                });
        };

        if( id > 0 )
        {
            vm.reload();
        }

        vm.exporter = [];
        vm.reloadexporter = function () {
            $http.get('/api/agent/cloudmon/exporter' ).then(
                function successCallback(response) {
                    if (response.data.stat){
                        vm.exporter = response.data.data
                    }else {
                        swal('获取信息失败', response.data.info, 'error' );
                    }
                },
                function errorCallback (response ){
                    swal('获取信息失败', response.status, 'error' );
                });
        };

        vm.reloadexporter();
    }
})();

