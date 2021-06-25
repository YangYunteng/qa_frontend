<template>
  <div class="echartLayout">
    <div id="container" style="height: 100vh; width: 100vh;"></div>
  </div>
</template>

<script>
import echarts from 'echarts'
import imgSrc from './../assets/logo.png'
export default {
  name: "RelationGraph",
  props: ['question'],
  data() {
    return {
      myChart: null,
      chartData: [],
      chartLink: [],
      index1: 0
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
      await this.$axios.get('/userServer/question-answer/' + question,  {params: {question: question, limit: 10}}).then(async (resp) => {
        if (resp.status === 200) {
          let graphdata = [];
          let graphDataLink = [];
          console.log('resp: ',resp.data);
          this.$store.commit('setUserData2', resp.data.data);
          await this.$nextTick(() => {
            console.log(this.$store.getters.getUserData2);
            let ans = resp.data.data;

            if (ans == null || ans.length === 0) {
              graphdata.push({name: '还没有数据哦！', id: '1', symbolSize: 76});
            } else {
              graphdata.push({name: ans[0].subject, id: '1', symbolSize: 76})
              console.log('ans: ',ans)

              ans.forEach((item) => {
                console.log('item',item);
                item.objects.forEach((o)=>{
                  this.index1++;
                  console.log('o:'+ o);
                  graphdata.push({name: o, id:(this.index1 + 2).toString()});
                  graphDataLink.push({value: item.predicate, source: '1', target: (this.index1+ 2).toString()})
                })
              })
            }
            console.log(graphdata);
            console.log(graphDataLink);
            this.chartData = graphdata;
            this.chartLink = graphDataLink;
          })

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
            //symbol: `image://${imgSrc}`,
            symbolSize: 86,
            type: 'graph',
            links: this.chartLink,
            data: this.chartData
          }
        ]
      };
      this.myChart.setOption(option);
    },
  }
}
</script>

<style scoped>
.echartLayout {
  margin: 0;
  position: absolute;
  top: 0;
  left: 0;
  bottom: 0;
  right: 0;
}
</style>
