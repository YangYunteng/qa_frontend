<template>
  <div class="echartLayout" style="width:100%; height:100%; overflow:hidden;">
    <div id="container" style="width:100%; height:100%; overflow:hidden;"></div>
  </div>
</template>

<script>
import echarts from 'echarts'
import QARobot from "@/components/QARobot/QARobot";
export default {
  name: "RelationGraph",
  props: ['question'],
  data() {
    return {
      myChart: null,
      chartData: [],
      chartLink: []
    }
  },
  mounted() {
    this.showMapDialogue(this.question).then(() => {
      this.initEchart();
    });
  },
  methods: {

    async showMapDialogue(question) {
      this.showMapDialog = true;
      await this.$axios.get('/userServer/question-answer/' + question, {
        limit: 10
      }).then(async (resp) => {
        if (resp.status === 200) {
          let graphdata = [];
          let graphDataLink = [];
          this.$store.commit('setUserData2', resp.data.data);
          await this.$nextTick(async () => {
            console.log(this.$store.getters.getUserData2);
            let ans = this.$store.getters.getUserData2;

            if (ans == null || ans.length === 0) {
              graphdata.push({name: '还没有数据哦！', id: '1', symbolSize: 76});
            } else {
              graphdata.push({name: ans[0].subject, id: '1', symbolSize: 76})

              ans.forEach((item, index) => {
                graphdata.push({name: item.object, id: String.valueOf(index + 2)});
                graphDataLink.push({value: item.object, source: '1', target: String.valueOf(index + 2)})

              })

            }
          })
          console.log(graphdata);
          console.log(graphDataLink);
          this.chartData = graphdata;
          this.chartLink = graphDataLink;
        }
      })
    },
    async initEchart() {
      let wait = () => setTimeout(async () => {
        if (document.getElementById("container") == undefined) await wait();
      }, 10);
      await wait();
      let dom = document.getElementById("container");
      this.myChart = echarts.init(dom);
      let option = {
        tooltip: {
          show: false
        },
        series: [
          {
            edgeLabel: {
              normal: {
                formatter: "{c}",
                show: true
              }
            },
            edgeSymbol: 'circle',
            force: {
              repulsion: 2000
            },
            layout: 'force',
            roam: true,
            itemStyle: {
              normal: {
                color: '#6495ED'
              },
              //鼠标放上去有阴影效果
              emphasis: {
                shadowColor: '#3721db',
                shadowOffsetX: 0,
                shadowOffsetY: 0,
                shadowBlur: 40,
              },
            },
            label: {
              normal: {
                show: true
              }
            },
            //头像
            symbol: `https://img.zcool.cn/community/01b0645a112c1ea80121985c0ea3d0.jpg@1280w_1l_2o_100sh.jpg`,
            symbolSize: 86,
            type: 'graph',
            links: this.chartLink,
            data: this.chartData
          }
        ]
      };
      this.myChart.setOption(option);
      this.myChart.on('click', function (params) {
        console.log(params.data)//获取点击的头像的数据信息
      });

    },
  }
}
</script>

<style scoped>
.echartLayout {
  margin: auto;
  position: absolute;
  top: 0;
  left: 0;
  bottom: 0;
  right: 0;
}
</style>
