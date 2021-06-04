<template>
  <v-app :class="app.backgroundStyle" id="home">
    <HomeNavigation></HomeNavigation>
    <v-main class="mt-8">
      <MindMap :tag-list-org="tagListOrg" style="width: 700px;
            height: 500px;
            margin:50px auto;
            position: relative;">
      </MindMap>


    </v-main>
    <HomeFooter></HomeFooter>
  </v-app>
</template>

<script>
// @ is an alias to /src
import HomeNavigation from "@/components/HomeNavigation";
import HomeFooter from "@/components/HomeFooter";
import MindMap from "@/components/MindMap";

export default {
  name: 'Home',
  components: {
    HomeNavigation,
    HomeFooter,
    MindMap
  },
  data() {
    return {
      app: this.$root.$children[0],
      tagListOrg:[{name:'清峪路万镇路', url:'www.baidu.com'},
        {name:'共和新路彭江路', url:'www.baidu.com'},
        {name:'淞沪路政立路', url:'www.baidu.com'},
        {name:'复旦大学', url:'www.baidu.com'},
        {name:'衡山路高安路', url:'www.baidu.com'},
        {name:'德平路浦东大道', url:'www.baidu.com'},
        {name:'上南路昌里路', url:'www.baidu.com'},
        {name:'高平路交城路', url:'www.baidu.com'},
        {name:'都市路金都路', url:'www.baidu.com'},
        {name:'南桥汽车站', url:'www.baidu.com'}]
    }
  }

}
</script>

<style>
.darkBg {
  background: url("../assets/dark_bg.jpg") center fixed !important;
}

.lightBg {
  background: url("../assets/light_bg.jpg") center fixed !important;
}
</style>
