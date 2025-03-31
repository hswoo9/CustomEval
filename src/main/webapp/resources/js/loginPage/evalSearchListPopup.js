var _g_contextPath_ = "${pageContext.request.contextPath}";
var evalSearchListPopup = {

    global: {},

    fn_defaultScript: function() {
        this.fn_makerGrid();
        $("#startDay").kendoTextBox();
    },

    fn_makerGrid: function() {
        var dataSource = new kendo.data.DataSource({
            serverPaging: false,
            pageSize: 20,
            transport: {
                read: {
                    url: _g_contextPath_ + "/login/getevalSearchList",
                    dataType: "json",
                    type: "post"
                },
                parameterMap: function(data, operation) {
                    data.startDay = $("#startDay").val();
                    return data;
                }
            },
            schema: {
                data: function(data) {
                    return data.list;
                }
            }
        });

        $("#mainGrid").kendoGrid({
            dataSource: dataSource,
            toolbar: [
                {
                    name: 'button',
                    template: function(e) {
                        return '<button type="button" class="k-grid-button k-button k-button-md k-rounded-md k-button-solid k-button-solid-base" onclick="evalSearchListPopup.fn_selectevalList()">' +
                            '<span class="k-button-text">선택</span>' +
                            '</button>';
                    }
                }
            ],
            noRecords: {
                template: "<div style='margin: auto;'>데이터가 존재하지 않습니다.</div>"
            },
            height: 489,
            sortable: true,
            scrollable: true,
            pageable: {
                refresh: true,
                pageSize: 20,
                pageSizes: [20, 30, 50, "ALL"],
                buttonCount: 5,
                messages: {
                    display: "{0} - {1} of {2}",
                    itemsPerPage: "",
                    empty: "데이터가 없습니다."
                }
            },
            columns: [
                {
                    width: "40px",
                    field: "",
                    template: function(row) {
                        return "<input type='checkbox' name='checkbox' value='" + row.COMMITTEE_SEQ + "' class='k-checkbox checkbox'>";
                    }
                },
                {
                    field: "TITLE",
                    title: "평가명",
                    attributes: { "data-title": "TITLE" }
                },
                {
                    field: "REQ_DEPT_NAME",
                    title: "요구부서",
                    width:"90px;",
                },
                {
                    field: "MANAGER_NAME",
                    title: "담당자",
                    width:"75px;",
                },
                {
                    field: "EVAL_E_DATE",
                    title: "평가일시",
                    width:"90px;",
                }
            ]
        });

        console.log("kendoGrid 초기화 완료");
    },

    fn_gridReload: function() {
        var grid = $("#mainGrid").data("kendoGrid");
        if (grid) {
            grid.dataSource.read();
        } else {
            console.error("kendoGrid가 초기화되지 않았습니다.");
        }
    },

    fn_selectevalList: function() {
        var selectedTitles = [];
        var selectedValues = [];

        var committeeSeq = $("[name='checkbox']:checked").val();

        $("input[name='checkbox']:checked").each(function () {
            selectedValues.push($(this).val()); // 선택된 항목의 값
            selectedTitles.push($(this).closest("tr").find("td[data-title]").text()); // 선택된 항목의 제목
        });

        if (selectedValues.length === 0) {
            alert("선택된 항목이 없습니다.");
            return;
        }

        if (selectedValues.length > 1) {
            alert("선택된 항목이 2개 이상입니다.");
            return;
        }


        window.opener.document.getElementById("commtitle").value = selectedTitles[0];
        window.opener.document.getElementById("committeeSeq").value = committeeSeq;

        // 팝업창 닫기
        window.close();
    }

};


evalSearchListPopup.fn_defaultScript();
